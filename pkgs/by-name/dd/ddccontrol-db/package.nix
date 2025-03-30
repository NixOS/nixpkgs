{
  lib,
  stdenv,
  autoreconfHook,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20250320";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = version;
    sha256 = "sha256-KhZp0gGGK27hAtfAwuff7VI9Z3D4MtMxkNW6l6B56Xw=";
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
