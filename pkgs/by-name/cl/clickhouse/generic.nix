{
  lts ? false,
  version,
  rev,
  hash,
}:

{
  lib,
  stdenv,
  llvmPackages_19,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  python3,
  perl,
  nasm,
  yasm,
  nixosTests,
  darwin,
  findutils,
  libiconv,
  removeReferencesTo,
  rustSupport ? true,
  rustc,
  cargo,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
let
  llvmStdenv = llvmPackages_19.stdenv;
in
llvmStdenv.mkDerivation (finalAttrs: {
  pname = "clickhouse";
  inherit version;
  inherit rev;

  src = fetchFromGitHub rec {
    owner = "ClickHouse";
    repo = "ClickHouse";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    name = "clickhouse-${tag}.tar.gz";
    inherit hash;
    postFetch = ''
      # Delete files that make the source too big
      rm -rf $out/contrib/arrow/docs/
      rm -rf $out/contrib/arrow/testing/
      rm -rf $out/contrib/aws/generated/protocol-tests/
      rm -rf $out/contrib/aws/generated/smoke-tests/
      rm -rf $out/contrib/aws/generated/tests/
      rm -rf $out/contrib/aws/tools/
      rm -rf $out/contrib/cld2/internal/test_shuffle_1000_48_666.utf8.gz
      rm -rf $out/contrib/croaring/benchmarks/
      rm -rf $out/contrib/boost/doc/
      rm -rf $out/contrib/boost/libs/*/bench/
      rm -rf $out/contrib/boost/libs/*/example/
      rm -rf $out/contrib/boost/libs/*/doc/
      rm -rf $out/contrib/boost/libs/*/test/
      rm -rf $out/contrib/google-cloud-cpp/ci/abi-dumps/
      rm -rf $out/contrib/icu/icu4c/source/test/
      rm -rf $out/contrib/icu/icu4j/main/core/src/test/
      rm -rf $out/contrib/icu/icu4j/perf-tests/
      rm -rf $out/contrib/llvm-project/*/docs/
      rm -rf $out/contrib/llvm-project/*/test/
      rm -rf $out/contrib/llvm-project/*/unittests/
      rm -rf $out/contrib/postgres/doc/

      # As long as we're not running tests, remove test files
      rm -rf $out/tests/

      # fix case insensitivity on macos https://github.com/NixOS/nixpkgs/issues/39308
      rm -rf $out/contrib/sysroot/linux-*
      rm -rf $out/contrib/liburing/man

      # Compress to not exceed the 2GB output limit
      echo "Creating deterministic source tarball..."

      tar -I 'gzip -n' \
        --sort=name \
        --mtime=1970-01-01 \
        --owner=0 --group=0 \
        --numeric-owner --mode=go=rX,u+rw,a-s \
        --transform='s@^@source/@S' \
        -cf temp  -C "$out" .

      echo "Finished creating deterministic source tarball!"

      rm -r "$out"
      mv temp "$out"
    '';
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    python3
    perl
    llvmPackages_19.lld
    removeReferencesTo
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    nasm
    yasm
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages_19.bintools
    findutils
    darwin.bootstrap_cmds
  ]
  ++ lib.optionals rustSupport [
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dontCargoSetupPostUnpack = true;

  patches =
    lib.optional (lib.versions.majorMinor version == "25.8") (fetchpatch {
      # Disable building WASM lexer
      url = "https://github.com/ClickHouse/ClickHouse/commit/67a42b78cdf1c793e78c1adbcc34162f67044032.patch";
      hash = "sha256-7VF+JSztqTWD+aunCS3UVNxlRdwHc2W5fNqzDyeo3Fc=";
    })
    ++

      lib.optional (lib.versions.majorMinor version == "25.8" && stdenv.hostPlatform.isDarwin)
        (fetchpatch {
          # Do not intercept memalign on darwin
          url = "https://github.com/ClickHouse/ClickHouse/commit/0cfd2dbe981727fb650f3b9935f5e7e7e843180f.patch";
          hash = "sha256-1iNYZbugX2g2dxNR1ZiUthzPnhLUR8g118aG23yhgUo=";
        })
    ++ lib.optional (!lib.versionAtLeast version "25.11" && stdenv.hostPlatform.isDarwin) (fetchpatch {
      # Remove flaky macOS SDK version detection
      url = "https://github.com/ClickHouse/ClickHouse/commit/11e172a37bd0507d595d27007170090127273b33.patch";
      hash = "sha256-oI7MrjMgJpIPTsci2IqEOs05dUGEMnjI/WqGp2N+rps=";
    });

  postPatch = ''
    patchShebangs src/ utils/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/tools.cmake \
      --replace-fail 'gfind' 'find' \
      --replace-fail 'ggrep' 'grep' \
      --replace-fail '--ld-path=''${LLD_PATH}' '-fuse-ld=lld'

    substituteInPlace utils/list-licenses/list-licenses.sh \
      --replace-fail 'gfind' 'find' \
      --replace-fail 'ggrep' 'grep'
  ''
  # Rust is handled by cmake
  + lib.optionalString rustSupport ''
    cargoSetupPostPatchHook() { true; }
  '';

  # Set the version the same way as ClickHouse CI does.
  #
  # https://github.com/clickhouse/clickhouse/blob/31127f21f8bb7ff21f737c4822de10ef5859c702/ci/jobs/scripts/clickhouse_version.py#L11-L20
  # https://github.com/clickhouse/clickhouse/blob/31127f21f8bb7ff21f737c4822de10ef5859c702/ci/jobs/build_clickhouse.py#L179
  preConfigure =
    let
      gitTagName = finalAttrs.version;
      versionStr = builtins.elemAt (lib.splitString "-" gitTagName) 0;

      parts = lib.splitVersion versionStr;

      major = builtins.elemAt parts 0;
      minor = builtins.elemAt parts 1;
      patch = builtins.elemAt parts 2;

      # The full commit hash is already available here:
      gitHash = rev;
    in
    ''
      cat <<'EOF' > cmake/autogenerated_versions.txt
      SET(VERSION_REVISION 0)
      SET(VERSION_MAJOR ${major})
      SET(VERSION_MINOR ${minor})
      SET(VERSION_PATCH ${patch})
      SET(VERSION_GITHASH ${gitHash})
      SET(VERSION_DESCRIBE ${gitTagName})
      SET(VERSION_STRING ${versionStr})
      EOF
    '';

  cmakeFlags = [
    "-DENABLE_CHDIG=OFF"
    "-DENABLE_TESTS=OFF"
    "-DENABLE_DELTA_KERNEL_RS=0"
    "-DCOMPILER_CACHE=disabled"
  ]
  ++ lib.optional (
    stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64
  ) "-DNO_ARMV81_OR_HIGHER=1";

  env = {
    CARGO_HOME = "$PWD/../.cargo/";
    NIX_CFLAGS_COMPILE =
      # undefined reference to '__sync_val_compare_and_swap_16'
      lib.optionalString stdenv.hostPlatform.isx86_64 " -mcx16"
      +
        # Silence ``-Wimplicit-const-int-float-conversion` error in MemoryTracker.cpp and
        # ``-Wno-unneeded-internal-declaration` TreeOptimizer.cpp.
        lib.optionalString stdenv.hostPlatform.isDarwin
          " -Wno-implicit-const-int-float-conversion -Wno-unneeded-internal-declaration";
  };

  # https://github.com/ClickHouse/ClickHouse/issues/49988
  hardeningDisable = [ "fortify" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  preVersionCheck = ''
    version=${builtins.head (lib.splitString "-" version)}
  '';

  postInstall = ''
    sed -i -e '\!<log>/var/log/clickhouse-server/clickhouse-server\.log</log>!d' \
      $out/etc/clickhouse-server/config.xml
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace-fail "<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>" "<console>1</console>" \
      --replace-fail "<level>trace</level>" "<level>warning</level>"
    remove-references-to -t ${llvmStdenv.cc} $out/bin/clickhouse
  '';

  # canary for the remove-references-to hook failing
  disallowedReferences = [ llvmStdenv.cc ];

  # Basic smoke test
  doCheck = true;
  checkPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $NIX_BUILD_TOP/$sourceRoot/build/programs/clickhouse local --query 'SELECT 1' | grep 1
  '';

  # Builds in 7+h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    tests = if lts then nixosTests.clickhouse-lts else nixosTests.clickhouse;

    updateScript = [
      ./update.sh

      (if lts then ./lts.nix else ./package.nix)
    ];
  };

  meta = with lib; {
    homepage = "https://clickhouse.com";
    description = "Column-oriented database management system";
    license = licenses.asl20;
    changelog = "https://github.com/ClickHouse/ClickHouse/blob/v${version}/CHANGELOG.md";

    mainProgram = "clickhouse";

    # not supposed to work on 32-bit https://github.com/ClickHouse/ClickHouse/pull/23959#issuecomment-835343685
    platforms = lib.filter (x: (lib.systems.elaborate x).is64bit) (platforms.linux ++ platforms.darwin);
    broken = stdenv.buildPlatform != stdenv.hostPlatform;

    maintainers = with maintainers; [
      thevar1able
    ];
  };
})
