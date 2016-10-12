{ stdenv, fetchurl, pkgconfig, perl, autoconf, automake
, libX11, inputproto, libXt, libXpm, libXft, libXtst, xextproto, libXi
, fontconfig, freetype, readline
}:

stdenv.mkDerivation rec {
  name = "ratpoison-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "mirror://savannah/ratpoison/${name}.tar.xz";
    sha256 = "1w502z55vv7zs45l80nsllqh9fvfwjfdfi11xy1qikhzdmirains";
  };

  buildInputs =
    [ pkgconfig perl autoconf automake
      libX11 inputproto libXt libXpm libXft libXtst xextproto libXi
      fontconfig freetype readline ];

  inherit patches;

  meta = with stdenv.lib; {
    homepage = "http://www.nongnu.org/ratpoison/";
    description = "Simple mouse-free tiling window manager";
    license = licenses.gpl2Plus;

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

    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
