{
  lib,
  mkDerivation,
  fetchFromGitHub,
  fetchurl,
  povray,
  qmake,
  qttools,
  replaceVars,
  zlib,
}:

/*
  To use aditional parts libraries
  set the variable LEOCAD_LIB=/path/to/libs/ or use option -l /path/to/libs/
*/

let
  parts = fetchurl {
    url = "https://web.archive.org/web/20250205180625/https://library.ldraw.org/library/updates/complete.zip";
    sha256 = "sha256-nYbQy48t5B6orpa3ShZVPVczciq2Kx36+ibFYNslDHw=";
  };

in
mkDerivation rec {
  pname = "leocad";
  version = "23.03";

  src = fetchFromGitHub {
    owner = "leozide";
    repo = "leocad";
    rev = "v${version}";
    sha256 = "sha256-IY9mr2gSMZL9pxiVTKH/f7rjsOvBDNgwVKpXA57oMGo=";
  };

  nativeBuildInputs = [
    qmake
    qttools
  ];

  buildInputs = [ zlib ];

  propagatedBuildInputs = [ povray ];

  patches = [
    (replaceVars ./povray.patch {
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
