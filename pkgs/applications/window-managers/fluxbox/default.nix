{ stdenv, fetchurl, pkgconfig
, freetype, fribidi
, libXext, libXft, libXpm, libXrandr, libXrender, xextproto
, libXinerama
, imlib2 }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "fluxbox-${version}";
  version = "1.3.7";

  buildInputs = [ pkgconfig freetype fribidi libXext libXft libXpm libXrandr libXrender xextproto libXinerama imlib2 ];

  src = fetchurl {
    url = "mirror://sourceforge/fluxbox/${name}.tar.xz";
    sha256 = "1h1f70y40qd225dqx937vzb4k2cz219agm1zvnjxakn5jkz7b37w";
  };

  meta = {
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
