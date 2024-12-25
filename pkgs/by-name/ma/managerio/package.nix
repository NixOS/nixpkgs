{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "manager";
  version = "24.12.23.1999";
  src = fetchurl {
    url = "https://github.com/Manager-io/Manager/releases/download/${version}/Manager-linux-x64.AppImage";
    hash = "sha256-Q4bH1cFvZfNSOWGXmg/RAOtjK6u5p2iRfUrOvetnoOs=";
  };
  meta = {
    description = "Free accounting software for Windows, Mac and Linux";
    homepage = "https://www.manager.io/";
    maintainers = with lib.maintainers; [ darwincereska ];
    license = with lib.licenses; [ free ]; # Unspecified freeware
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
      # "x86_64-windows" # Windows ones are optional, really, feel free to exclude them
      # "i686-windows"
    ];
  };
}
