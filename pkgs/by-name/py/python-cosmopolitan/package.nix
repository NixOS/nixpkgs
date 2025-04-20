{
  lib,
  stdenvNoCC,
  cosmopolitan,
  unzip,
  bintools-unwrapped,
}:

stdenvNoCC.mkDerivation {
  pname = "python-cosmopolitan";
  version = "3.6.14";

  src = cosmopolitan.dist;

  nativeBuildInputs = [
    bintools-unwrapped
    unzip
  ];

  # slashes are significant because upstream uses o/$(MODE)/foo.o
  buildFlags = [ "o//third_party/python" ];
  checkTarget = "o//third_party/python/test";
  enableParallelBuilding = true;

  doCheck = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 o/third_party/python/freeze $out/bin/freeze
    install -Dm755 o/third_party/python/pycomp $out/bin/pycomp
    install -Dm755 o/third_party/python/pystone $out/bin/pystone
    install -Dm755 o/third_party/python/pythontester $out/bin/pythontester
    install -Dm755 o/third_party/python/hello $out/bin/hello
    install -Dm755 o/third_party/python/pyobj $out/bin/pyobj
    install -Dm755 o/third_party/python/python3 $out/bin/python3
    install -Dm755 o/third_party/python/repl $out/bin/repl

    runHook postInstall
  '';

  meta = {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "Actually Portable Python using Cosmopolitan";
    platforms = lib.platforms.x86_64;
    badPlatforms = lib.platforms.darwin;
    license = lib.licenses.isc;
    teams = [ lib.teams.cosmopolitan ];
    mainProgram = "python3";
  };
}
