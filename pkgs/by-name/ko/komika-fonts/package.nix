{
  stdenvNoCC,
  lib,
  fetchzip,
  variants ? [
    "display"
    "hand"
    "poster"
    "text"
    "title"
  ],
}:

let
  fetchFont =
    {
      url,
      hash,
      curlOptsList ? [ ],
    }:
    fetchzip {
      inherit url hash curlOptsList;
      name = lib.nameFromURL url ".";
      stripRoot = false;
    };
  fontMap = {
    "display" = {
      url = "https://www.1001fonts.com/download/komika-display.zip";
      hash = "sha256-6oNKuaoV+a/cFCKFXRV8gtWqvFtPGtrqg+vt8hQREMI=";
    };
    "hand" = {
      url = "https://www.1001fonts.com/download/komika.zip";
      hash = "sha256-yb5SWQj7BRCLYHL31m25bhCOuo8qAvkRzGH6UIo3Bbs=";
    };
    "poster" = {
      url = "https://www.1001freefonts.com/d/5010/komika-poster.zip";
      hash = "sha256-k1uUfHSh9kymCJrfuPtKHejFeZGl2PxL4C/3hpoPIc4=";
      curlOptsList = [
        "-H"
        "Referer: https://www.1001freefonts.com/komika-poster.font"
      ];
    };
    "text" = {
      url = "https://www.1001fonts.com/download/komika-text.zip";
      hash = "sha256-FdeFGw6MlYVTiYdvbfjSlQYq+UlKZTJ79HAdEEjMPQs=";
    };
    "title" = {
      url = "https://www.1001freefonts.com/d/5011/komika-title.zip";
      hash = "sha256-M/1NgsHjLR/w/ZxWEb5cebqEI1VKgPvtk75bhAPaw20=";
      curlOptsList = [
        "-H"
        "Referer: https://www.1001freefonts.com/komika-title.font"
      ];
    };

  };
  knownFonts = lib.attrNames fontMap;
  selectedFonts =
    if (variants == [ ]) then
      lib.warn "No variants selected, installing all instead" knownFonts
    else
      let
        unknown = lib.subtractLists knownFonts variants;
      in
      if (unknown != [ ]) then
        throw "Unknown variant(s): ${lib.concatStringsSep " " unknown}"
      else
        variants;

in
stdenvNoCC.mkDerivation {
  pname = "komika-fonts";
  version = "0-unstable-2001-06-16";
  sourceRoot = ".";

  srcs = map (variant: fetchFont fontMap.${variant}) selectedFonts;
  installPhase = ''
    runHook preInstall
    install -Dm444 **/*.ttf -t $out/share/fonts/ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://pedroreina.net/apostrophiclab/";
    description = "First ever comic lettering super family";
    longDescription = ''
      50 fonts, covering everything the comic artist needs when it comes to lettering. 10 text faces, 10 display faces, 10 tiling faces, 10 hand variations, 9 poster faces, and 20 balloons in a font.
    '';
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pancaek ];
    platforms = lib.platforms.all;
  };
}
