{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  gettext,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "kvirc";
  version = "2022-06-29";

  src = fetchFromGitHub {
    owner = "kvirc";
    repo = "KVIrc";
    rev = "eb3fdd6b1d824f148fd6e582852dcba77fc9a271";
    sha256 = "sha256-RT5UobpMt/vBLgWur1TkodS3dMyIWQkDPiBYCYx/FI4=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.qtsvg
    libsForQt5.qtx11extras
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    libsForQt5.wrapQtAppsHook
  ];

  meta = {
    description = "Advanced IRC Client";
    homepage = "https://www.kvirc.net/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.suhr ];
    platforms = lib.platforms.linux;
  };
}
