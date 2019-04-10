{ stdenv, fetchFromGitHub, qmake, qttools }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "1dgag8j3566qwiz1pschfq2wqdp7y1pr4cm9na4zwrdjhn3ci6v5";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools ];

  preConfigure = ''
    substituteInPlace src/common/programpaths.cpp --replace /usr/share/ $out/share/
    lrelease lang/*.ts
  '';

  installPhase = ''
    install -Dm755 GPXSee $out/bin/GPXSee
    mkdir -p $out/share/gpxsee
    cp -r pkg/csv $out/share/gpxsee/
    cp -r pkg/maps $out/share/gpxsee/
    mkdir -p $out/share/gpxsee/translations
    cp -r lang/*.qm $out/share/gpxsee/translations
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.gpxsee.org/;
    description = "GPX viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports GPX,
      TCX, KML, FIT, IGC, NMEA, SLF, LOC and OziExplorer files.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
