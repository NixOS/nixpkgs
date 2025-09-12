{ lib, fetchurl }:
fetchurl rec {
  pname = "lucide";
  version = "0.541.0";

  url = "https://unpkg.com/lucide-static@${version}/font/Lucide.ttf";
  hash = "sha256-b6zAx9b89oYS1Vrm7XR8Uu0M6unmTfC3o9Q2ZAuCrjo=";

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
