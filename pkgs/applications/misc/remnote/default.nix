{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "remnote";
  version = "1.7.6";

  src = fetchurl {
    url = "https://download.remnote.io/RemNote-${version}.AppImage";
    sha256 = "sha256-yRUpLev/Fr3mOamkFgevArv2UoXgV4e6zlyv7FaQ4RM=";
  };

  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
