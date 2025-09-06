{
  lts ? false,
  version,
  hash,
  nixUpdateExtraArgs ? [ ],
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
  rustSupport ? true,
  rustc,
  cargo,
  rustPlatform,
  nix-update-script,
}:

llvmPackages_19.stdenv.mkDerivation (finalAttrs: {
  pname = "clickhouse" + lib.optionalString lts "-lts";
  inherit version;

  src = fetchFromGitHub rec {
    owner = "ClickHouse";
    repo = "ClickHouse";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    name = "clickhouse-${tag}.tar.gz";
    inherit hash;
    postFetch = ''
      # delete files that make the source too big
      rm -rf $out/contrib/llvm-project/llvm/test
      rm -rf $out/contrib/llvm-project/clang/test
      rm -rf $out/contrib/croaring/benchmarks

      # fix case insensitivity on macos https://github.com/NixOS/nixpkgs/issues/39308
      rm -rf $out/contrib/sysroot/linux-*
      rm -rf $out/contrib/liburing/man

      # compress to not exceed the 2GB output limit
      # try to make a deterministic tarball
      tar -I 'gzip -n' \
        --sort=name \
        --mtime=1970-01-01 \
        --owner=0 --group=0 \
        --numeric-owner --mode=go=rX,u+rw,a-s \
        --transform='s@^@source/@S' \
        -cf temp  -C "$out" .
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
      sha256 = "7VF+JSztqTWD+aunCS3UVNxlRdwHc2W5fNqzDyeo3Fc=";
    })
    ++

      lib.optional (lib.versions.majorMinor version == "25.8" && stdenv.hostPlatform.isDarwin)
        (fetchpatch {
          # Do not intercept memalign on darwin
          url = "https://github.com/ClickHouse/ClickHouse/commit/0cfd2dbe981727fb650f3b9935f5e7e7e843180f.patch";
          sha256 = "1iNYZbugX2g2dxNR1ZiUthzPnhLUR8g118aG23yhgUo=";
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

  postInstall = ''
    sed -i -e '\!<log>/var/log/clickhouse-server/clickhouse-server\.log</log>!d' \
      $out/etc/clickhouse-server/config.xml
    substituteInPlace $out/etc/clickhouse-server/config.xml \
      --replace-fail "<errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>" "<console>1</console>" \
      --replace-fail "<level>trace</level>" "<level>warning</level>"
  '';

  # Basic smoke test
  doCheck = true;
  checkPhase = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $NIX_BUILD_TOP/$sourceRoot/build/programs/clickhouse local --query 'SELECT 1' | grep 1
  '';

  # Builds in 7+h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    tests = if lts then nixosTests.clickhouse-lts else nixosTests.clickhouse;

    updateScript = nix-update-script {
      extraArgs = nixUpdateExtraArgs;
    };
  };

  meta = with lib; {
    homepage = "https://clickhouse.com";
    description = "Column-oriented database management system";
    license = licenses.asl20;
    maintainers = with maintainers; [
      orivej
      mbalatsko
      thevar1able
    ];

    # not supposed to work on 32-bit https://github.com/ClickHouse/ClickHouse/pull/23959#issuecomment-835343685
    platforms = lib.filter (x: (lib.systems.elaborate x).is64bit) (platforms.linux ++ platforms.darwin);
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
})
