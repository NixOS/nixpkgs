{ stdenv, fetchurl, libX11, inputproto, libXt, libXpm, libXft, fontconfig, freetype
, libXtst, xextproto, readline, libXi, pkgconfig, perl, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "ratpoison-1.4.6";

  src = fetchurl {
    url = "mirror://savannah/ratpoison/${name}.tar.gz";
    sha256 = "1y1b38bng0naxfy50asshzg5xr1b2rn88mcgbds42y72d7y9d0za";
  };

  buildInputs =
    [ libX11 inputproto libXt libXpm libXft fontconfig freetype libXtst
      xextproto readline libXi pkgconfig perl autoconf automake
    ];

  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2"; # urgh

  preConfigure = "autoreconf -vf";      # needed because of the patch above

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    mv "$out/share/ratpoison/"*.el $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = "http://www.nongnu.org/ratpoison/";
    description = "Ratpoison, a simple mouse-free tiling window manager";
    license = stdenv.lib.licenses.gpl2Plus;

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

    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
