{ lib
, stdenv
, fetchFromGitHub
, cmake
, gd
}:

stdenv.mkDerivation rec {
  pname = "libansilove";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "ansilove";
    repo = "libansilove";
    rev = version;
    hash = "sha256-5ieahoxxT+7O47ZNP0hRzUOSCg9ayTqDq0soMhmVNpk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gd ];

  meta = with lib; {
    description = "Library for converting ANSI, ASCII, and other formats to PNG";
    homepage = "https://www.ansilove.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kip93 ];
  };
}
