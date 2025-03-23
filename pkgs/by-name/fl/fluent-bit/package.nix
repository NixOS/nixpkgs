{
  lib,
  stdenv,
  arrow-glib,
  bison,
  c-ares,
  cmake,
  curl,
  fetchFromGitHub,
  flex,
  jemalloc,
  libbacktrace,
  libbpf,
  libnghttp2,
  libpq,
  libyaml,
  luajit,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  rdkafka,
  systemd,
  versionCheckHook,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fluent-bit";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E+y8lZ5fgJORFkig6aSVMYGk0US1b4xwjO9qnGu4R/Y=";
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
  # See https://github.com/fluent/fluent-bit/blob/v3.2.6/CMakeLists.txt#L211-L218.
  #
  # Like `FLB_PREFER_SYSTEM_LIBS`, several CMake options aren't documented.
  #
  # See https://github.com/fluent/fluent-bit/blob/v3.2.6/CMakeLists.txt#L111-L157.
  #
  # The CMake options may differ across target platforms. We'll stick to the minimum.
  #
  # See https://github.com/fluent/fluent-bit/tree/v3.2.6/packaging/distros.

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
      # Needed by rdkafka.
      curl
      jemalloc
      libbacktrace
      libnghttp2
      libpq
      libyaml
      luajit
      openssl
      rdkafka
      # Needed by rdkafka.
      zlib
      # Needed by rdkafka.
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # libbpf doesn't build for Darwin yet.
      libbpf
      systemd
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
