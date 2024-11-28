{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "1";
  minorVersion = "00";
in
stdenvNoCC.mkDerivation {
  pname = "nacelle";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/nacelle_${majorVersion}${minorVersion}.zip";
    hash = "sha256-e4QsPiyfWEAYHWdwR3CkGc2UzuA3hZPYYlWtIubY0Oo=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/nacelle/";
    description = "Improved version of the Aileron font";
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
    license = licenses.ofl;
  };
}
