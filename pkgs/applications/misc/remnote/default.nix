{ lib, fetchurl, appimageTools, makeDesktopItem }:

appimageTools.wrapType2 rec {
  pname = "remnote";
  version = "1.12.18";
  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    sha256 = "sha256-z/LTsX65rN+AJbpCTzIabpgUadFe6SnRRDKOkexZyjQ=";
  };
  icon = fetchurl {
    url = "https://www.remnote.io/icon.png";
    sha256 = "sha256-r5D7fNefKPdjtmV7f/88Gn3tqeEG8LGuD4nHI/sCk94=";
  };
  desktopItem = makeDesktopItem {
    type = "Application";
    name = "remnote";
    desktopName = "RemNote";
    comment = "Spaced Repetition";
    icon = "remnote";
    exec = "remnote %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/remnote" "x-scheme-handler/rn" ];
  };

  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman jgarcia ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
