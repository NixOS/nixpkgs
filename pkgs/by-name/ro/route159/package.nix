{ lib, stdenvNoCC, fetchzip }:

let
  majorVersion = "1";
  minorVersion = "10";
in
stdenvNoCC.mkDerivation {
  pname = "route159";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/route159_${majorVersion}${minorVersion}.zip";
    hash = "sha256-1InyBW1LGbp/IU/ql9mvT14W3MTxJdWThFwRH6VHpTU=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/route159/";
    description = "Weighted sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars minijackson ];
    license = licenses.ofl;
  };
}
