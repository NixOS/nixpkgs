{stdenv, fetchurl, x11, motif, libXpm}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "nedit-5.5";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/nedit-5.5-src.tar.bz2;
    md5 = "48cb3dce52d44988f3a4d7c6f47b6bbe";
  };
  patches = [./dynamic.patch];

  inherit motif;
  buildInputs = [x11 motif libXpm];

  makeFlags = if stdenv.system == "i686-linux" then "linux" else "";
}
