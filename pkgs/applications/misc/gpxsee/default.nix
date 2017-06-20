{ stdenv, fetchFromGitHub, qmake, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "17s1v6b1j7pi0yj554bd0cg14bl854gssp5gj2pl51rxji6zr0wp";
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
