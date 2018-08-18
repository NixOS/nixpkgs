{ stdenv, fetchFromGitHub, qmake, qttools }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "4.19";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "1xjf2aawf633c1ydhpcsjhdlfkjkfsjbcgjd737xpfv1wjz99l4l";
  };

  nativeBuildInputs = [ qmake qttools ];

  preConfigure = ''
    substituteInPlace src/config.h --replace /usr/share/gpxsee $out/share/gpxsee
    lrelease lang/*.ts
  '';

  preFixup = ''
    install -Dm755 GPXSee $out/bin/GPXSee

    mkdir -p $out/share/gpxsee
    cp pkg/maps.txt $out/share/gpxsee
  '';

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
