{ stdenv, fetchFromGitHub, qmakeHook, qttools }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "15f686frxlrmdvh5cc837kx62g0ihqj4vb87i8433g7l5vqkv3lf";
  };

  nativeBuildInputs = [ qmakeHook qttools ];

  preConfigure = ''
    lrelease lang/*.ts
  '';

  preFixup = ''
    mkdir -p $out/bin
    cp GPXSee $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://tumic.wz.cz/gpxsee;
    description = "GPX viewer and analyzer";
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
