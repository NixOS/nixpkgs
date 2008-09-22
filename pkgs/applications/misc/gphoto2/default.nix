{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.4.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "0wna84rli816d830hirdv3ficr3q16zs471l725rgsdvc4pqrvy9";
  };
  
  buildInputs = [pkgconfig libgphoto2 libexif popt gettext libjpeg readline libtool];
  
  # There is a bug in 2.4.0 configure.ac (in their m4 macroses)
  #patchPhase = "sed -e 's@_tmp=true@_tmp=false@' -i configure configure.ac";

  meta = {
    homepage = http://www.gphoto.org/;
  };
}
