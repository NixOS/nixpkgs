{ stdenv, fetchFromGitHub, qmake, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "4.14";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "0yv3hcs5b8a88mp24h8r2sn69phwrahdff5pp74lz24270il3jgb";
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
    homepage = http://tumic.wz.cz/gpxsee;
    description = "GPX viewer and analyzer";
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
