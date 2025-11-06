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
  pname = "medio";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/medio_${majorVersion}${minorVersion}.zip";
    hash = "sha256-S+CcwD4zGVk7cIFD6K4NnpE/0mrJq4RnDJC576rhcLQ=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/medio/";
    description = "Serif font designed by Sora Sagano";
    longDescription = ''
      Medio is a serif font designed by Sora Sagano, based roughly
      on the proportions of the font Tenderness (from the same designer),
      but with hairline serifs in the style of a Didone.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [
      leenaars
      minijackson
    ];
    license = licenses.cc0;
  };
}
