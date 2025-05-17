{ lib
, stdenv
, fetchFromGitHub
, cmake
, libansilove
}:

stdenv.mkDerivation rec {
  pname = "ansilove";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "ansilove";
    rev = version;
    hash = "sha256-cIJBerIbVY/V2LVupBLapmeHDWlBd49M5IjKPFM5OcE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libansilove ];

  meta = with lib; {
    mainProgram = "ansilove";
    description = "ANSI and ASCII art to PNG converter in C";
    homepage = "https://www.ansilove.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kip93 ];
  };
}
