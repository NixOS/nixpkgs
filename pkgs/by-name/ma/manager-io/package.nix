{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "manager-io";
  version = "24.12.23.1999";
  src = fetchurl {
    url = "https://github.com/Manager-io/Manager/releases/download/${version}/Manager-linux-x64.AppImage";
    hash = "sha256-Q4bH1cFvZfNSOWGXmg/RAOtjK6u5p2iRfUrOvetnoOs=";
  };

  extraPkgs =
    pkgs: with pkgs; [
      icu
    ];
  meta = {
    description = "Accounting software for Windows, Mac and Linux";
    homepage = "https://www.manager.io";
    maintainers = with lib.maintainers; [ darwincereska ];
    license = with lib.licenses; [ unfree ]; # Unspecified freeware
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
