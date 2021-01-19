{ lib, stdenv, fetchurl, perl, libxcb }:

stdenv.mkDerivation {
  name = "lemonbar-1.4";

  src = fetchurl {
    url    = "https://github.com/LemonBoy/bar/archive/v1.4.tar.gz";
    sha256 = "0fa91vb968zh6fyg97kdaix7irvqjqhpsb6ks0ggcl59lkbkdzbv";
  };

  buildInputs = [ libxcb perl ];

  prePatch = ''sed -i "s@/usr@$out@" Makefile'';

  meta = with lib; {
    description = "A lightweight xcb based bar";
    homepage = "https://github.com/LemonBoy/bar";
    maintainers = [ maintainers.meisternu ];
    license = "Custom";
    platforms = platforms.linux;
  };
}
