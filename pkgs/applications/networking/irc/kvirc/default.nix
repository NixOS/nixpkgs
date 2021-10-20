{ lib, mkDerivation, fetchFromGitHub
, qtbase, qtmultimedia, qtsvg, qtx11extras
, pkg-config, cmake, gettext
}:

mkDerivation rec {
  pname = "kvirc";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "kvirc";
    repo = "KVIrc";
    rev = version;
    sha256 = "1dq7v6djw0gz56rvghs4r5gfhzx4sfg60rnv6b9zprw0vlvcxbn4";
  };

  buildInputs = [
    qtbase qtmultimedia qtsvg qtx11extras
  ];

  nativeBuildInputs = [
    pkg-config cmake gettext
  ];

  meta = with lib; {
    description = "Advanced IRC Client";
    homepage = "http://www.kvirc.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.suhr ];
    platforms = platforms.linux;
  };
}
