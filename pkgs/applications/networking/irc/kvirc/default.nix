{ lib, mkDerivation, fetchFromGitHub
, qtbase, qtmultimedia, qtsvg, qtx11extras
, pkg-config, cmake, gettext
}:

mkDerivation rec {
  pname = "kvirc";
  version = "2022-06-29";

  src = fetchFromGitHub {
    owner = "kvirc";
    repo = "KVIrc";
    rev = "eb3fdd6b1d824f148fd6e582852dcba77fc9a271";
    sha256 = "sha256-RT5UobpMt/vBLgWur1TkodS3dMyIWQkDPiBYCYx/FI4=";
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
