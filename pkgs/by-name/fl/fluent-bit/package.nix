{
  lib,
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
  libyaml,
  luajit,
  nix-update-script,
  nixosTests,
  openssl,
  pkg-config,
  postgresql,
  rdkafka,
  stdenv,
  systemd,
  versionCheckHook,
  zlib,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "fluent-bit";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "fluent";
    repo = "fluent-bit";
    tag = "v${version}";
    hash = "sha256-oTCGjDmGVovsfj+4fjIKy/xpiuYc0Q44LYwYPI4dSF8=";
  };

  # `src/CMakeLists.txt` installs fluent-bit's systemd unit files at the path in the `SYSTEMD_UNITDIR` CMake variable.
  #
  # The initial value of `SYSTEMD_UNITDIR` is set in `cmake/FindJournald` which uses pkg-config to find the systemd
  # unit directory. `src/CMakeLists.txt` only sets `SYSTEMD_UNITDIR` to `/lib/systemd/system` if it's unset.
  #
  # Unfortunately, this resolves to systemd's Nix store path which is immutable. Consequently, CMake fails when trying
  # to install fluent-bit's systemd unit files to the systemd Nix store path.
  #
  # We fix this by replacing `${SYSTEMD_UNITDIR}` instances in `src/CMakeLists.txt`.
  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail \''${SYSTEMD_UNITDIR} $out/lib/systemd/system
  '';

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
  # See https://github.com/fluent/fluent-bit/blob/v3.2.3/CMakeLists.txt#L211-L218.
  #
  # Like `FLB_PREFER_SYSTEM_LIBS`, several CMake options aren't documented.
  #
  # See https://github.com/fluent/fluent-bit/blob/v3.2.3/CMakeLists.txt#L111-L157.
  #
  # The CMake options may differ across target platforms. We'll stick to the minimum.
  #
  # See https://github.com/fluent/fluent-bit/tree/v3.2.3/packaging/distros.

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
      libyaml
      luajit
      openssl
      postgresql
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

  outputs = [
    "out"
    "dev"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${builtins.placeholder "out"}/bin/fluent-bit";

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
    maintainers = with lib.maintainers; [ samrose ];
  };
}
