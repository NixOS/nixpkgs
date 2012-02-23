{ stdenv, fetchurl, intltool, pkgconfig, gtk, GConf, alsaLib }:

stdenv.mkDerivation rec {
  name = "gmtk-1.0.5";

  src = fetchurl {
    url = "http://gmtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "a07130d62719e8c1244f8405dd97445798df5204fc0f3f2f2b669b125114b468";
  };

  buildInputs = [ intltool pkgconfig gtk GConf alsaLib ];
}

