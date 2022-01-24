{ stdenv
, lib
, fetchFromGitHub
, intltool
, gobject-introspection
, gmime
, libxml2
, libsoup
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "xplayer-plparser";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "1i7sld8am6b1wwbpfb18v7qp17vk2a5p8xcfds50yznr30lddsb2";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    gmime
    libxml2
    libsoup
  ];

  meta = with lib; {
    description = "Playlist parsing library for xplayer";
    homepage = "https://github.com/linuxmint/xplayer-plparser";
    maintainers = with maintainers; [ tu-maurice ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
