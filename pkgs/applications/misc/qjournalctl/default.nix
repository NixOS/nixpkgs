{ stdenv, fetchFromGitHub, qtbase, qmake }:

stdenv.mkDerivation rec {
  pname = "qjournalctl";
  version = "unstable-2018-11-25";

  src = fetchFromGitHub {
    owner = "pentix";
    repo = pname;
    rev = "80463d38dc52e2fce457ab66114edf1fdf951e73";
    sha256 = "10b76ywbnyvwik4apn0c1y0vjb6xg53ksxyzrh194z2ppw0c3r0r";
  };

  postPatch = ''
    substituteInPlace qjournalctl.pro --replace /usr/ $out/
  '';

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase ];

  meta = with stdenv.lib; {
    description = "Qt-based Graphical User Interface for systemd's journalctl command";
    homepage = https://github.com/pentix/qjournalctl;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
