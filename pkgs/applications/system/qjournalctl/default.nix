{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qmake,
  pkg-config,
  libssh,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qjournalctl";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "pentix";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-anNNzqjbIaQI+MAwwMwzy6v4SKqi4u9F5IbFBErm4q8=";
  };

  postPatch = ''
    substituteInPlace qjournalctl.pro --replace /usr/ $out/
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libssh
    qtbase
  ];

  meta = with lib; {
    description = "Qt-based graphical user interface for systemd's journalctl command";
    mainProgram = "qjournalctl";
    homepage = "https://github.com/pentix/qjournalctl";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ romildo ];
  };
}
