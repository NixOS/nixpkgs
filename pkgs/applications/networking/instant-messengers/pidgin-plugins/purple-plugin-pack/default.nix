{ lib, stdenv, fetchurl, pidgin, intltool, python2 } :

stdenv.mkDerivation rec {
  pname = "purple-plugin-pack";
  version = "2.7.0";
  src = fetchurl {
    url = "https://bitbucket.org/rekkanoryo/purple-plugin-pack/downloads/purple-plugin-pack-${version}.tar.bz2";
    sha256 = "0g5hmy7fwgjq59j52h9yps28jsjjrfkd4r18gyx6hfd3g3kzbg1b";
  };

  buildInputs = [ pidgin intltool python2 ];

  meta = with lib; {
    homepage = "https://bitbucket.org/rekkanoryo/purple-plugin-pack";
    description = "Plugin pack for Pidgin 2.x";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bdimcheff ];
  };
}
