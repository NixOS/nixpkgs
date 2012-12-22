{ stdenv, fetchurl, libX11, inputproto, libXt, libXpm, libXft, fontconfig, freetype
, libXtst, xextproto, readline, libXi, pkgconfig, perl, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "ratpoison-1.4.5";

  src = fetchurl {
    url = "mirror://savannah/ratpoison/${name}.tar.gz";
    sha256 = "7391079db20b8613eecfd81d64d243edc9d3c586750c8f2da2bb9db14d260f03";
  };

  buildInputs =
    [ libX11 inputproto libXt libXpm libXft fontconfig freetype libXtst
      xextproto readline libXi pkgconfig perl autoconf automake
    ];

  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2"; # urgh

  preConfigure = "autoreconf -vf";      # needed because of the patch above

  patches = [ ./glibc-fix.patch ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    mv "$out/share/ratpoison/"*.el $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = "http://www.nongnu.org/ratpoison/";
    description = "Ratpoison, a simple mouse-free tiling window manager";
    license = "GPLv2+";

    longDescription = ''
       Ratpoison is a simple window manager with no fat library
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

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
