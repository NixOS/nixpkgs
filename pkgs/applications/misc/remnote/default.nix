{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "remnote";
  version = "1.12.18";
  src = fetchurl {
    url = "https://download.remnote.io/remnote-desktop/RemNote-${version}.AppImage";
    sha256 = "sha256-z/LTsX65rN+AJbpCTzIabpgUadFe6SnRRDKOkexZyjQ=";
  };
  icon = fetchurl {
    url = "https://www.remnote.io/remnote.png";
    sha256 = "sha256-BylzKYH4Kk4N6AI1FrvOtpZEpRSUqBy3zuHh+XMjhA4=";
  };

  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman jgarcia ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
