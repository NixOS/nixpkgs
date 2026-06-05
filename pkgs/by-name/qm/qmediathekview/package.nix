{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  xz,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "QMediathekView";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "adamreichold";
    repo = "QMediathekView";
    rev = "v${version}";
    sha256 = "0i9hac9alaajbra3lx23m0iiq6ww4is00lpbzg5x70agjrwj0nd6";
  };

  postPatch = ''
    substituteInPlace QMediathekView.pro \
      --replace /usr ""
  '';

  buildInputs = [
    libsForQt5.qtbase
    xz
    boost
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = {
    description = "Alternative Qt-based front-end for the database maintained by the MediathekView project";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "QMediathekView";
  };
}
