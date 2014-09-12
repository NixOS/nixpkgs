{ stdenv, fetchurl, pkgconfig
, freetype, fribidi
, libXext, libXft, libXpm, libXrandr, libXrender, xextproto
, libXinerama
, imlib2 }:

stdenv.mkDerivation rec {

  name = "fluxbox-${version}";
  version = "1.3.5";

  buildInputs = [ pkgconfig freetype fribidi libXext libXft libXpm libXrandr libXrender xextproto libXinerama imlib2 ];

  src = fetchurl {
    url = "mirror://sourceforge/fluxbox/${name}.tar.bz2";
    sha256 = "164dd7bf59791d09a1e729a4fcd5e7347a1004ba675629860a5cf1a271c32983";
  };

  meta = with stdenv.lib; {
    description = "Full-featured, light-resource X window manager";
    longDescription = ''
      Fluxbox is a X window manager based on Blackbox 0.61.1 window
      manager sources.  It is very light on resources and easy to
      handle but yet full of features to make an easy, and extremely
      fast, desktop experience. It is written in C++ and licensed
      under MIT license.
    '';
    homepage = http://fluxbox.org/;
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# Many thanks Jack Ryan from Nix-dev mailing list!
