{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "jcal";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "fzerorubigd";
    repo = "jcal";
    rev = "v${version}";
    sha256 = "sha256-vJc5uijZlvohEtiS03LYlqtswVE38S9/ejlHrmZ0wqA=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ readline ];

  preAutoreconf = "cd sources/";

  meta = with lib; {
    description = "Jalali calendar is a small and portable free software library to manipulate date and time in Jalali calendar system";
    homepage = "http://nongnu.org/jcal/";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
