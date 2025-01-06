{
  lib,
  mkFranzDerivation,
  fetchurl,
}:

mkFranzDerivation rec {
  pname = "franz";
  name = "Franz";
  version = "5.10.0";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb";
    sha256 = "sha256-zQhZlxr7kyMWx6txDnV+ECBTzVEwnUaBsLWKJy3XYFg=";
  };
  meta = {
    description = "Free messaging app that combines chat & messaging services into one application";
    homepage = "https://meetfranz.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.davidtwco ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
