{ lib
, stdenvNoCC
, fetchurl
}:

# Metadata fetched from
#  https://www.googleapis.com/webfonts/v1/webfonts?key=${GOOGLE_FONTS_TOKEN}&family=Noto+Emoji
let
  metadata = with builtins; head (fromJSON (readFile ./noto-emoji.json)).items;
  urlHashes = with builtins; fromJSON (readFile ./noto-emoji.hashes.json);
in
stdenvNoCC.mkDerivation {
  pname = "noto-fonts-monochrome-emoji";
  version = "${lib.removePrefix "v" metadata.version}.${metadata.lastModified}";
  preferLocalBuild = true;

  dontUnpack = true;
  srcs =
    let
      weightNames = {
        "300" = "Light";
        regular = "Regular";
        "500" = "Medium";
        "600" = "SemiBold";
        "700" = "Bold";
      };
    in
    lib.mapAttrsToList
      (variant: url: fetchurl {
        name = "NotoEmoji-${weightNames.${variant}}.ttf";
        hash = urlHashes.${url};
        inherit url;
      })
      metadata.files;

  installPhase = ''
    runHook preInstall
    for src in $srcs; do
      install -D $src $out/share/fonts/noto/$(stripHash $src)
    done
    runHook postInstall
  '';

  meta = {
    description = "Monochrome emoji font";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Emoji";
    license = [ lib.licenses.ofl ];
    maintainers = [ lib.maintainers.nicoo ];

    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
