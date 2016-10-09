{ stdenv, fetchurl, perl, libxcb }:

stdenv.mkDerivation rec {
  name = "lemonbar-1.2";
  
  src = fetchurl {
    url    = "https://github.com/LemonBoy/bar/archive/v1.2.tar.gz";
    sha256 = "1smz8lh930bnb6a4lrm07l3z2k071kc8p2pljk5wsrch3x2xhimq";
  };
  
  buildInputs = [ libxcb perl ];
  
  prePatch = ''sed -i "s@/usr@$out@" Makefile'';
  
  meta = with stdenv.lib; {
    description = "A lightweight xcb based bar";
    homepage = https://github.com/LemonBoy/bar;
    maintainers = [ maintainers.meisternu ];
    license = "Custom";   
    platforms = platforms.linux;
  };
}
