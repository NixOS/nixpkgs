{
  lib,
  stdenv,
  autoreconfHook,
  intltool,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "ddccontrol-db";
  version = "20250220";

  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = pname;
    rev = version;
    sha256 = "sha256-QSz9zPgLoFlskeltD8bvtNdNEmXNW7ZBh7GA4CQCa7k=";
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
