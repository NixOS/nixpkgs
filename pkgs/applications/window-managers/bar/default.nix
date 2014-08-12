{ stdenv, fetchurl, git, perl, libxcb, libXinerama, xcbutil, xcbutilwm, xcbutilkeysyms }:

stdenv.mkDerivation rec {
  name = "bar";
  version = "1.0";
  
  src = fetchurl {
    url = "https://github.com/LemonBoy/${name}/archive/v${version}.tar.gz";
    sha256 = "1n2vak2acs37sslxl250cnz9c3irif5z4s54wi9qjyxbfzr2h2nc";
  };

  buildInputs = [ libxcb git perl libXinerama xcbutil xcbutilkeysyms xcbutilwm ];

  prePatch = ''sed -i "s@/usr@$out@" Makefile'';

  meta = {
    description = "A lightweight xcb based bar";
    homepage = "https://github.com/LemonBoy/bar";
    maintainers = stdenv.lib.maintainers.meisternu;
    license = "Custom";   
    platforms = stdenv.lib.platforms.linux;
  };
}
