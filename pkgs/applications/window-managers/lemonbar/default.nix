{ stdenv, fetchurl, perl, libxcb }:

stdenv.mkDerivation rec {
  name = "lemonbar-1.3";
  
  src = fetchurl {
    url    = "https://github.com/LemonBoy/bar/archive/v1.3.tar.gz";
    sha256 = "0zd3v8ys4jzi60pm3wq7p3pbbd5y0acimgiq46qx1ckmwg2q9rza";
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
