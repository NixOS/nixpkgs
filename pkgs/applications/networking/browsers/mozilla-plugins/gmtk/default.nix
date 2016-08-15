{ stdenv, fetchurl, intltool, pkgconfig, gtk, GConf, alsaLib }:

stdenv.mkDerivation rec {
  name = "gmtk-1.0.9b";

  src = fetchurl {
    url = "http://gmtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "07y5hd94qhvlk9a9vhrpznqaml013j3rq52r3qxmrj74gg4yf4zc";
  };

  buildInputs = [ intltool pkgconfig gtk GConf alsaLib ];

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
