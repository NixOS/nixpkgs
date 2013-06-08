{stdenv, fetchurl, x11, motif, libXpm}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "nedit-5.5";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://nl.nedit.org/ftp/v5_5/nedit-5.5-src.tar.bz2;
    md5 = "48cb3dce52d44988f3a4d7c6f47b6bbe";
  };
  patches = [./dynamic.patch];

  inherit motif;
  buildInputs = [x11 motif libXpm];

  buildFlags = if stdenv.isLinux then "linux" else "";

  meta = {
    homepage = http://www.nedit.org;
  };
}
