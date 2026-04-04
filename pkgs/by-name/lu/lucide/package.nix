{ lib, fetchurl }:
fetchurl rec {
  pname = "lucide";
  version = "0.563.0";

  url = "https://unpkg.com/lucide-static@${version}/font/Lucide.ttf";
  hash = "sha256-dBE3gAmhffBsqZNp8rS4bzV8zIF538I1z/DRgk/oO2M=";

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    cp -a $downloadedFile $out/share/fonts/truetype/Lucide.ttf
  '';

  meta = {
    homepage = "https://lucide.dev/";
    description = "Open-source icon library that provides 1000+ icons";
    downloadPage = url;
    platforms = lib.platforms.all;
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.janTatesa ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
