{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "remnote";
  version = "1.12.3";

  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    sha256 = "sha256-qLEEIzTE5h9+9tWL0qSFCqN/MW124NtIacqiKnhlbp8=";
  };

  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman jgarcia ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
