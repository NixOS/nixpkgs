{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "remnote";
  version = "1.8.52";

  src = fetchurl {
    url = "https://download.remnote.io/RemNote-${version}.AppImage";
    sha256 = "sha256-0t4i/4dlZ1tv4kz8eD5cjIuhx0lT8dQbh+bpjqAfqTE=";
  };

  meta = with lib; {
    description = "A note-taking application focused on learning and productivity";
    homepage = "https://remnote.com/";
    maintainers = with maintainers; [ max-niederman ];
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
