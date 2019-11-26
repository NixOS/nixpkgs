{ mkDerivation, lib, fetchFromGitHub, qmake, qttools }:

mkDerivation rec {
  pname = "gpxsee";
  version = "7.18";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "1z3knfqfv0rwsq66adk0qngw1r500yvy4z259bygqkzbn2l5fcjk";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools ];

  preConfigure = ''
    lrelease lang/*.ts
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://www.gpxsee.org/;
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ womfoo sikmir ];
    platforms = platforms.linux;
  };
}
