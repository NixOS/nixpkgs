{ stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt, gettext
, libjpeg, readline, libtool
}:

stdenv.mkDerivation rec {
  name = "gphoto2-2.4.5";
  
  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "0bjbgz9n7ijf8167i1bm7q3pg366axgx5zydck13d2znhd30x069";
  };
  
  buildInputs = [pkgconfig libgphoto2 libexif popt gettext libjpeg readline libtool];
  
  # There is a bug in 2.4.0 configure.ac (in their m4 macroses)
  #patchPhase = "sed -e 's@_tmp=true@_tmp=false@' -i configure configure.ac";

  meta = {
    homepage = http://www.gphoto.org/;
  };
}
