{
  stdenvNoCC,
  lib,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lucide";
  version = "0.541.0";

  src = fetchurl {
    url = "https://unpkg.com/lucide-static@${finalAttrs.version}/font/Lucide.ttf";
    hash = "sha256-H8ACnTkbR4N3yYbWuteZoqfPlLu+OGm/NEfweBad8uM=";
  };

  sourceRoot = ".";

  unpackCmd = ''
    ttfName=$(basename $(stripHash $curSrc))
    cp $curSrc ./$ttfName
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a *.ttf $out/share/fonts/truetype/
  '';

  meta = {
    homepage = "https://lucide.dev/";
    description = "Open-source icon library that provides 1000+ icons";
    platforms = lib.platforms.all;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ janTatesa ];
  };
})
