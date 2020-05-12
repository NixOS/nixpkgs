{ stdenv, fetchFromGitHub, perl, libxcb, libXft }:

stdenv.mkDerivation {
  name = "lemonbar-xft-unstable-2016-02-17";

  src = fetchFromGitHub {
    owner  = "krypt-n";
    repo   = "bar";
    rev    = "a43b801ddc0f015ce8b1211f4c062fad12cd63a9";
    sha256 = "0iqas07qjvabxyvna2m9aj5bcwnkdii1izl9jxha63vz0zlsc4gd";
  };

  buildInputs = [ libxcb libXft perl ];

  prePatch = ''sed -i "s@/usr@$out@" Makefile'';

  meta = {
    description = "A lightweight xcb based bar with XFT-support";
    homepage = "https://github.com/krypt-n/bar";
    license = "Custom";
    platforms = stdenv.lib.platforms.linux;
  };
}
