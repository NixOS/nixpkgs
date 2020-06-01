{ stdenv, mkDerivation, fetchFromGitHub, qmake, qttools }:

mkDerivation rec {
  pname = "gpxsee";
  version = "7.29";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "sha256-OTKyxEu7RZZy3JBHTM7YoH+G4lhoRfb1INLtQEKC5p4=";
  };

  nativeBuildInputs = [ qmake qttools ];

  preConfigure = ''
    lrelease gpxsee.pro
  '';

  postInstall = with stdenv; lib.optionalString isDarwin ''
    mkdir -p $out/Applications
    mv GPXSee.app $out/Applications
    wrapQtApp $out/Applications/GPXSee.app/Contents/MacOS/GPXSee
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://www.gpxsee.org/";
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = with platforms; linux ++ darwin;
  };
}
