{ stdenv, fetchFromGitHub, qtbase, qttools, xz, boost, qmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "QMediathekView";
  version = "2017-04-16";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "adamreichold";
    repo = pname;
    rev = "8c69892b95bf6825bd06a8c594168a98fe7cb2d1";
    sha256 = "1wca1w4iywd3hmiwcqx6fv79p3x5n1cgbw2liw3hs24ch3z54ckm";
  };

  postPatch = ''
    substituteInPlace ${pname}.pro \
      --replace /usr ""
  '';

  buildInputs = [ qtbase qttools xz boost ];

  nativeBuildInputs = [ qmake pkgconfig ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with stdenv.lib; {
    description = "An alternative Qt-based front-end for the database maintained by the MediathekView project";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
