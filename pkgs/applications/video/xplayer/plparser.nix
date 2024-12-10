{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  gobject-introspection,
  gmime3,
  libxml2,
  libsoup,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "xplayer-plparser";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "6GMKsIpyQdiyHPxrjWHAHvuCouJxrAcYPIo9u6TLOA4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    gmime3
    libxml2
    libsoup
  ];

  meta = with lib; {
    description = "Playlist parsing library for xplayer";
    homepage = "https://github.com/linuxmint/xplayer-plparser";
    maintainers = with maintainers; [
      tu-maurice
      bobby285271
    ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
