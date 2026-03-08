{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "1";
  minorVersion = "00";
in
stdenvNoCC.mkDerivation {
  pname = "nacelle";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/files/fonts/nacelle_${majorVersion}${minorVersion}.zip";
    hash = "sha256-e4QsPiyfWEAYHWdwR3CkGc2UzuA3hZPYYlWtIubY0Oo=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://dotcolon.net/font/nacelle/";
    description = "Improved version of the Aileron font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ minijackson ];
    license = lib.licenses.ofl;
  };
}
