{ 
  stdenv,
  fetchFromGitHub,
  qtbase,
  qmake,
  pkgconfig,
  libssh,
	wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qjournalctl";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "pentix";
    repo = pname;
    rev = "v${version}";
    sha256 = "08qfcf5yrfzsis9gkawkhshwmmi0jqw8xv23925hqass4a2xz704";
  };

  postPatch = ''
    substituteInPlace qjournalctl.pro --replace /usr/ $out/
  '';

  nativeBuildInputs = [ qmake pkgconfig libssh ];
  buildInputs = [ qtbase wrapQtAppsHook];

  meta = with stdenv.lib; {
    description = "Qt-based Graphical User Interface for systemd's journalctl command";
    homepage = https://github.com/pentix/qjournalctl;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill srgom ];
    platforms = platforms.all;
  };
}
