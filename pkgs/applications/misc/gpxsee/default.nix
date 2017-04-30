{ stdenv, fetchFromGitHub, qmakeHook, qtbase, qttools, makeQtWrapper }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "15f686frxlrmdvh5cc837kx62g0ihqj4vb87i8433g7l5vqkv3lf";
  };

  nativeBuildInputs = [ qmakeHook qttools makeQtWrapper ];

  preConfigure = ''
    substituteInPlace src/config.h --replace /usr/share/gpxsee $out/share/gpxsee
    lrelease lang/*.ts
  '';

  preFixup = ''
    install -Dm755 GPXSee $out/bin/GPXSee
    wrapQtProgram $out/bin/GPXSee

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
