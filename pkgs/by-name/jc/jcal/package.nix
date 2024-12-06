{ lib, stdenv, fetchFromGitHub, autoreconfHook
, readline
}:

stdenv.mkDerivation rec {
  pname = "jcal";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fzerorubigd";
    repo = "jcal";
    rev = "v${version}";
    sha256 = "0m3g3rf0ycv2dsfn9y2472fa3r0yla8pfqk6gq00nrscsc3pp4zf";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ readline ];

  preAutoreconf = "cd sources/";

  meta = with lib; {
    description = "Jalali calendar is a small and portable free software library to manipulate date and time in Jalali calendar system";
    homepage =  "http://nongnu.org/jcal/";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
