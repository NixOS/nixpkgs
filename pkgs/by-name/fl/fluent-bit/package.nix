{
  lib,
  stdenv,
  arrow-glib,
  bison,
  c-ares,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  flex,
  jemalloc,
  libbacktrace,
  libbpf,
  nghttp2,
  libpq,
  libyaml,
  luajit,
  nix-update-script,
  nixosTests,
  msgpack-c,
  openssl,
  pkg-config,
  rdkafka,
  sqlite,
  systemd,
  versionCheckHook,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluent-bit";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UMWYybrk0TRV5adFbL2J0EOjOUvv7vQgas36CpaJG9I=";
  };

  # The source build documentation covers some dependencies and CMake options.
  #
  # - Linux: https://docs.fluentbit.io/manual/installation/sources/build-and-install
  # - Darwin: https://docs.fluentbit.io/manual/installation/macos#compile-from-source
  #
  # Unfortunately, fluent-bit vends many dependencies (e.g. luajit) as source files and tries to compile them by
  # default, with none of their dependencies and CMake options documented.
  #
  # Fortunately, there's the undocumented `FLB_PREFER_SYSTEM_LIBS` CMake option to link against system libraries for
  # some dependencies.
  #
  # See https://github.com/fluent/fluent-bit/blob/v4.0.2/CMakeLists.txt#L245

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs =
    [
      arrow-glib
      c-ares
      jemalloc
      libbacktrace
      nghttp2.dev
      msgpack-c
      libpq
      libyaml
      luajit
      openssl
      rdkafka
      sqlite.dev
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # libbpf doesn't build for Darwin yet.
      libbpf
      systemd
    ];

  patches = [
    (fetchpatch {
      url = "https://github.com/fluent/fluent-bit/pull/10387/commits/8b42317b4b6da9836bd8506e2f38164bf0bfb3df.patch";
      hash = "sha256-kBQrfnOVBTILEtv+5rqvwo5oKS1reTiM8RPlCX917eM=";
    })
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "FLB_RELEASE" true)
      (lib.cmakeBool "FLB_PREFER_SYSTEM_LIBS" true)
    ]
    ++ lib.optionals stdenv.cc.isClang [
      # `FLB_SECURITY` causes bad linker options for Clang to be set.
      (lib.cmakeBool "FLB_SECURITY" false)
    ];

  # `src/CMakeLists.txt` installs fluent-bit's systemd unit files at the path in the `SYSTEMD_UNITDIR` CMake variable.
  #
  # The initial value of `SYSTEMD_UNITDIR` is set in `cmake/FindJournald` which uses pkg-config to find the systemd
  # unit directory in the systemd package's `systemdsystemunitdir` pkg-config variable. `src/CMakeLists.txt` only
  # sets `SYSTEMD_UNITDIR` to `/lib/systemd/system` if it's unset.
  #
  # By default, this resolves to systemd's Nix store path which is immutable. Consequently, CMake fails when trying
  # to install fluent-bit's systemd unit files to the systemd Nix store path.
  #
  # We fix this by setting the systemd package's `systemdsystemunitdir` pkg-config variable.
  #
  # https://man.openbsd.org/pkg-config.1#PKG_CONFIG_$PACKAGE_$VARIABLE
  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${builtins.placeholder "out"}/lib/systemd/system";

  outputs = [
    "out"
    "dev"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru = {
    tests = lib.optionalAttrs stdenv.isLinux {
      inherit (nixosTests) fluent-bit;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast and lightweight logs and metrics processor for Linux, BSD, OSX and Windows";
    homepage = "https://fluentbit.io";
    license = lib.licenses.asl20;
    mainProgram = "fluent-bit";
    maintainers = with lib.maintainers; [ arianvp ];
  };
})
