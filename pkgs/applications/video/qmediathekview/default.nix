{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, boost
, qtbase
, xz
, qmake
, pkg-config
}:

mkDerivation rec {
  pname = "QMediathekView";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "adamreichold";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i9hac9alaajbra3lx23m0iiq6ww4is00lpbzg5x70agjrwj0nd6";
  };

  postPatch = ''
    substituteInPlace ${pname}.pro \
      --replace /usr ""
  '';

  buildInputs = [ qtbase xz boost ];

  nativeBuildInputs = [ qmake pkg-config ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    description = "An alternative Qt-based front-end for the database maintained by the MediathekView project";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
    broken = stdenv.isAarch64;
    mainProgram = "QMediathekView";
  };
}
