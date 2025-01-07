{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "200";
in
stdenvNoCC.mkDerivation {
  pname = "ferrum";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/ferrum_${majorVersion}${minorVersion}.zip";
    hash = "sha256-NDJwgFWZgyhMkGRWlY55l2omEw6ju3e3dHCEsWNzQIc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "http://dotcolon.net/font/ferrum/";
    description = "Decorative font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      leenaars
      minijackson
    ];
    license = lib.licenses.cc0;
  };
}
