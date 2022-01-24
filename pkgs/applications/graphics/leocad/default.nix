{ lib
, mkDerivation
, fetchFromGitHub
, fetchurl
, qmake
, qttools
, zlib
}:

/*
To use aditional parts libraries
set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

let
  parts = fetchurl {
    url = "https://web.archive.org/web/20190715142541/https://www.ldraw.org/library/updates/complete.zip";
    sha256 = "sha256-PW3XCbFwRaNkx4EgCnl2rXH7QgmpNgjTi17kZ5bladA=";
  };

in
mkDerivation rec {
  pname = "leocad";
  version = "21.03";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "sha256-69Ocfk5dBXwcRqAZWEP9Xg41o/tAQo76dIOk9oYhCUE=";
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ zlib ];

  qmakeFlags = [
    "INSTALL_PREFIX=${placeholder "out"}"
    "DISABLE_UPDATE_CHECK=1"
  ];

  qtWrapperArgs = [
    "--set-default LEOCAD_LIB ${parts}"
  ];

  meta = with lib; {
    description = "CAD program for creating virtual LEGO models";
    homepage = "https://www.leocad.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
