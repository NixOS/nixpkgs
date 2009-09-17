args: with args;

let s = import ./src-for-default.nix; in

stdenv.mkDerivation rec {
  inherit (s) version name;
  src = fetchurl {
    inherit(s) url;
    sha256 = s.hash;
  };

  buildInputs = [libX11 pkgconfig pcre GStreamer glib libxml2 aspell
    libXpm imlib2 xosd libXt libXext libXi libnotify gtk pango
    cairo];

  inherit aspell imlib2 xosd;

  preConfigure = ''
    sed -e 's/-Werror//' -i configure
    sed -e 's/for aspell_dir in/for aspell_dir in $aspell /' -i configure
    sed -e 's/for imlib2_dir in/for imlib2_dir in $imlib2 /' -i configure
    sed -e 's/for xosd_dir in/for xosd_dir in $xosd /' -i configure

    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/include/gtk-2.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/lib/gtk-2.0/include"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${cairo}/include/cairo"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pango}/include/pango-1.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${atk}/include/atk-1.0"

    export NIX_LDFLAGS="$NIX_LDFLAGS -lnotify"
  '';

  meta = {
    description = "xneur is the keyboard layout switcher.";
    homepage = http://xneur.ru;
    license = "GPL2+";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };

}
