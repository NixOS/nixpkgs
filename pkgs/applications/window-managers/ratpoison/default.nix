{ stdenv, fetchurl, libX11, inputproto, libXt, libXpm, libXft, fontconfig
, libXtst, xextproto, readline, libXi, pkgconfig, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "ratpoison-1.4.5";

  src = fetchurl {
    url = "mirror://savannah/ratpoison/${name}.tar.gz";
    sha256 = "7391079db20b8613eecfd81d64d243edc9d3c586750c8f2da2bb9db14d260f03";
  };

  patches =
    [ (fetchurl {
         url = "http://git.savannah.gnu.org/cgit/ratpoison.git/patch/?id=4ad0b38fb53506d613c4b4f7268dadfcedae9b8e";
         sha256 = "118c5b481fa22b8fefbe34e3dbb157f621a3bf5de0c7beb540001c99ff403a5f";
       })
    ];

  preConfigure = "autoreconf -vf";

  buildInputs =
    [ libX11 inputproto libXt
      libXpm libXft fontconfig libXtst
      xextproto readline libXi pkgconfig
      autoconf automake  # needed because of the patch above
    ];

  meta = {
    description = "Ratpoison, a simple mouse-free tiling window manager";
    longDescription =
      '' Ratpoison is a simple window manager with no fat library
         dependencies, no fancy graphics, no window decorations, and no
         rodent dependence.  It is largely modelled after GNU Screen which
         has done wonders in the virtual terminal market.

         The screen can be split into non-overlapping frames.  All windows
         are kept maximized inside their frames to take full advantage of
         your precious screen real estate.

         All interaction with the window manager is done through keystrokes.
         Ratpoison has a prefix map to minimize the key clobbering that
         cripples Emacs and other quality pieces of software.
      '';

    license = "GPLv2+";

    homepage = http://www.nongnu.org/ratpoison/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}

