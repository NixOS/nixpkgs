{stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt}:

stdenv.mkDerivation {
  name = "gphoto2-2.2.0";
  src = fetchurl {
    url = mirror://sourceforge/gphoto/gphoto2-2.2.0.tar.bz2;
    md5 = "f5c1f83185db598b4ca52889964a5e84";
  };
  buildInputs = [pkgconfig libgphoto2 libexif popt];
}
