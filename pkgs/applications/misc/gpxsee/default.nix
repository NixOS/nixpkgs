{ stdenv, fetchFromGitHub, qmake, qttools }:

stdenv.mkDerivation rec {
  pname = "gpxsee";
  version = "7.8";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "1ymqz4wrl9ghkyyqi2vrnlyvz3fc84s3p8a1dkiqlvyvj360ck9j";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools ];

  preConfigure = ''
    substituteInPlace src/common/programpaths.cpp --replace /usr/share/ $out/share/
    lrelease lang/*.ts
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.gpxsee.org/;
    description = "GPS log file viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports
      all common GPS log file formats.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
