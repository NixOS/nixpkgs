{ lib
, mkDerivation
, fetchFromGitHub
, fetchurl
, povray
, qmake
, qttools
, substituteAll
, zlib
}:

/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

let
  parts = fetchurl {
    url = "https://web.archive.org/web/20210705153544/https://www.ldraw.org/library/updates/complete.zip";
    sha256 = "sha256-PW3XCbFwRaNkx4EgCnl2rXH7QgmpNgjTi17kZ5bladA=";
  };

in
mkDerivation rec {
  pname = "leocad";
  version = "21.06";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "1ifbxngkbmg6d8vv08amxbnfvlyjdwzykrjp98lbwvgb0b843ygq";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ zlib ];

  propagatedBuildInputs = [ povray ];

  patches = [
    (substituteAll {
      src = ./povray.patch;
      inherit povray;
    })
  ];

  qmakeFlags = [
    "INSTALL_PREFIX=${placeholder "out"}"
    "DISABLE_UPDATE_CHECK=1"
  ];

  qtWrapperArgs = [
    "--set-default LEOCAD_LIB ${parts}"
  ];

  meta = with lib; {
    description = "CAD program for creating virtual LEGO models";
    mainProgram = "leocad";
    homepage = "https://www.leocad.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
