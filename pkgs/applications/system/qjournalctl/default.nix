{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qmake
, pkg-config
, libssh
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qjournalctl";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "pentix";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j27cmfq29mwrbjfrrwi6m1grcamhbfhk47xzlfsx5wr2q9m6qkz";
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
    homepage = "https://github.com/pentix/qjournalctl";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill srgom romildo ];
  };
}
