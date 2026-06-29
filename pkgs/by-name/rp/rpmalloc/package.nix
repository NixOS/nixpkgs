{
  lib,
  stdenv,
  ninja,
  python3,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "rpmalloc";
  version = "unstable-2025-05-26";

  src = fetchFromGitHub {
    owner = "mjansson";
    repo = "rpmalloc";
    rev = "66fd705a811764035ec80f54928748d2b31a3827";
    hash = "sha256-UBEZkeEP6YwpUIOVLc94AKq2dJS8jvcSfHMpPe88oI0=";
  };

  nativeBuildInputs = [
    ninja
    python3
  ];
  buildInputs = [ stdenv.cc ];

  outputs = [
    "out"
    "dev"
  ];

  configurePhase =
    let
      # despite the `gcc' label, the gcc implementation reads standard envvars
      # and is the best choice for a fallback. see upstream: `build/ninja/gcc.py'.
      toolchain = if stdenv.cc.isClang then "clang" else "gcc";
    in
    ''
      python3 $src/configure.py --toolchain ${toolchain} --config release
    '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    for testBin in bin/**/release/**/*-test ; do
      test -x $testBin && $testBin
    done
  '';

  installPhase =
    ''
      mkdir -p "''${!outputDev}/include"
      cp -r rpmalloc "''${!outputDev}/include/rpmalloc"
    ''
    + (lib.optionalString stdenv.hostPlatform.hasSharedLibraries ''
      mkdir -p $out/lib
      for shlib in build/ninja/**/release/**/rpmalloc-*/*.so ; do
        install $shlib $out/lib
      done
    '')
    + (lib.optionalString stdenv.hostPlatform.isStatic ''
      mkdir -p $out/lib
      for archive in build/ninja/**/release/**/rpmalloc-*/*.a ; do
        install $archive $out/lib
      done
    '');

  meta = {
    description = "Public domain cross platform lock free thread caching 16-byte aligned memory allocator implemented in C";
    homepage = " https://github.com/mjansson/rpmalloc";
    changelog = "https://github.com/mjansson/rpmalloc/blob/${src.rev}/CHANGELOG";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ sielicki ];
    mainProgram = "rpmalloc";
    platforms = lib.platforms.all;
  };
}
