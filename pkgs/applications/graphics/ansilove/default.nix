{ stdenv
, lib
, fetchFromGitHub
, cmake
, libansilove
}:

stdenv.mkDerivation rec {
  pname = "ansilove";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = pname;
    rev = version;
    hash = "sha256-cIJBerIbVY/V2LVupBLapmeHDWlBd49M5IjKPFM5OcE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libansilove ];

  meta = with lib; {
    homepage = "https://www.ansilove.org/";
    description = "ANSI and ASCII art to PNG converter in C";
    license = licenses.bsd2;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
