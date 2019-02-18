{ stdenv, fetchFromGitHub, qtbase, qttools, xz, boost, qmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "QMediathekView";
  version = "2019-01-06";

  src = fetchFromGitHub {
    owner = "adamreichold";
    repo = pname;
    rev = "e098aaec552ec4e367078bf19953a08067316b4b";
    sha256 = "0i9hac9alaajbra3lx23m0iiq6ww4is00lpbzg5x70agjrwj0nd6";
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
