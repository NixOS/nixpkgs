{ lib, fetchurl }:
fetchurl rec {
  pname = "lucide";
  version = "0.544.0";

  url = "https://unpkg.com/lucide-static@${version}/font/Lucide.ttf";
  hash = "sha256-Cf4vv+f3ZUtXPED+PCHxvZZDMF5nWYa4iGFSDQtkquQ=";

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
