{ stdenv, fetchurl, perl, libxcb }:

let
  version = "1.1";
in
  stdenv.mkDerivation rec {
    name = "bar-${version}";
  
    src = fetchurl {
      url = "https://github.com/LemonBoy/bar/archive/v${version}.tar.gz";
      sha256 = "171ciw676cvj80zzbqfbg9nwix36zph0683zmqf279q9b9bmayan";
    };
  
    buildInputs = [ libxcb perl ];
  
    prePatch = ''sed -i "s@/usr@$out@" Makefile'';
  
    meta = {
      description = "A lightweight xcb based bar";
      homepage = https://github.com/LemonBoy/bar;
      maintainers = [ stdenv.lib.maintainers.meisternu ];
      license = "Custom";   
      platforms = stdenv.lib.platforms.linux;
    };
}
