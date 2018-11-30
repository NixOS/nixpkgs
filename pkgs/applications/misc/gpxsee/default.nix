{ stdenv, fetchFromGitHub, qmake, qttools }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "0kbnmcis04kjqkd0msfjd8rdmdf23c71dpzx9wcpf2yadc9rv4c9";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qttools ];

  preConfigure = ''
    substituteInPlace src/config.h --replace /usr/share/gpxsee $out/share/gpxsee
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
    homepage = http://www.gpxsee.org/;
    description = "GPX viewer and analyzer";
    longDescription = ''
      GPXSee is a Qt-based GPS log file viewer and analyzer that supports GPX,
      TCX, KML, FIT, IGC and NMEA files.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
