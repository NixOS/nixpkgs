{ stdenv, fetchurl, intltool, pkgconfig, gtk, GConf, alsaLib }:

stdenv.mkDerivation rec {
  name = "gmtk-1.0.8";

  src = fetchurl {
    url = "http://gmtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "034b02nplb2bp01yn4p19345jh3yibhn4lcxznrzcsmsyj2vlzq0";
  };

  buildInputs = [ intltool pkgconfig gtk GConf alsaLib ];
}

