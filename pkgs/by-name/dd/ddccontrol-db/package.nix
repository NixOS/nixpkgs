{
  lib,
  stdenv,
  autoconf,
  automake,
  libtool,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20250814";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-DYDO7JZzriLdVKeqOaaEonHcdRaOD3SsvJPhScvSkVE=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
