{ lib, stdenv, fetchurl, appimageTools }:

stdenv.mkDerivation rec {
  pname = "remnote";
  version = "1.12.18";
  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    sha256 = "sha256-z/LTsX65rN+AJbpCTzIabpgUadFe6SnRRDKOkexZyjQ=";
  };
  appexec = appimageTools.wrapType2 {
    inherit pname version src;
  };
  icon = fetchurl {
    url = "https://www.remnote.io/icon.png";
    sha256 = "sha256-r5D7fNefKPdjtmV7f/88Gn3tqeEG8LGuD4nHI/sCk94=";
  };

  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman jgarcia ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
