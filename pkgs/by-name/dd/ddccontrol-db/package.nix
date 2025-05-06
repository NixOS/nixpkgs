{
  lib,
  stdenv,
  autoreconfHook,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20250504";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-C0FpasSh1fKA8Xcm080dYKyXREQ0Ryy5YBknEiuiLcM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
  ];

  meta = with lib; {
    description = "Monitor database for DDCcontrol";
    homepage = "https://github.com/ddccontrol/ddccontrol-db";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.pakhfn ];
  };
}
