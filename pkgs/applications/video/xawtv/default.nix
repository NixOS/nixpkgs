{stdenv, fetchurl, ncurses, libjpeg, libX11, libXt, libXft, xproto, libFS, fontsproto, libXaw, libXpm, libXext, libSM, libICE, perl, xextproto}:

stdenv.mkDerivation {
  name = "xawtv-3.95";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xawtv-3.95.tar.gz;
    md5 = "ad25e03f7e128b318e392cb09f52207d";
  };
  buildInputs = [ncurses libjpeg libX11 libXt libXft xproto libFS fontsproto libXaw libXpm libXext libSM libICE perl xextproto];
  patches = [./xawtv-3.95-libfs.patch ./xawtv-3.95-makefile.patch];
  
}
