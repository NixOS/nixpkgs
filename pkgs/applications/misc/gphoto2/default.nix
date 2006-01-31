{stdenv, fetchurl, pkgconfig, libgphoto2, libexif, popt}:

stdenv.mkDerivation {
  name = "gphoto2-2.1.99";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gphoto2-2.1.99.tar.bz2;
    md5 = "549a9dfae6910ab6456b194ea86b55a2";
  };
  buildInputs = [pkgconfig libgphoto2 libexif popt];
}
