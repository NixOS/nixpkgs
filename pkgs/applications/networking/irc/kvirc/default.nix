{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtmultimedia,
  qtsvg,
  qtx11extras,
  pkg-config,
  cmake,
  gettext,
  wrapQtAppsHook,
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
    qtbase
    qtmultimedia
    qtsvg
    qtx11extras
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    wrapQtAppsHook
  ];

  meta = {
    description = "Advanced IRC Client";
    homepage = "https://www.kvirc.net/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.suhr ];
    platforms = lib.platforms.linux;
  };
}
