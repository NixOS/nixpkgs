{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,

  arrow-glib,
  bison,
  c-ares,
  cmake,
  flex,
  jemalloc,
  libbacktrace,
  libbpf,
  libpq,
  libyaml,
  luajit,
  msgpack-c,
  nghttp2,
  nix-update-script,
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
  version = "4.0.10";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fYgZULGGlvuxgI5qOQ83AxcpEQQlw3ZpYLpu3hDJiSc=";
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
  # https://github.com/fluent/fluent-bit/blob/v4.0.2/CMakeLists.txt#L245

  strictDeps = true;

  nativeBuildInputs = [
    bison
    cmake
    flex
    pkg-config
  ];

  buildInputs = [
    arrow-glib
    c-ares
    jemalloc
    libbacktrace
    libpq
    libyaml
    luajit
    msgpack-c
    nghttp2.dev
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

  cmakeFlags = [
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
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
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
