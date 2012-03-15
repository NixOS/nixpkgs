{ stdenv, fetchurl, pkgconfig, xorg, pcre, gstreamer, glib, libxml2
, aspell, cairo, imlib2, xosd, libnotify, gtk, pango, atk, enchant,
 gdk_pixbuf}:

let s = import ./src-for-default.nix; in

stdenv.mkDerivation rec {
  inherit (s) version name;
  src = fetchurl {
    inherit(s) url;
    sha256 = s.hash;
  };

  buildInputs =
    [ xorg.libX11 pkgconfig pcre gstreamer glib libxml2 aspell cairo
      xorg.libXpm imlib2 xosd xorg.libXt xorg.libXext xorg.libXi libnotify
      gtk pango enchant gdk_pixbuf
    ];

  preConfigure = ''
    sed -e 's/-Werror//' -i configure
    sed -e 's@for aspell_dir in@for aspell_dir in ${aspell} @' -i configure
    sed -e 's@for imlib2_dir in@for imlib2_dir in ${imlib2} @' -i configure
    sed -e 's@for xosd_dir in@for xosd_dir in ${xosd} @' -i configure

    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/include/gtk-2.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/lib/gtk-2.0/include"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${cairo}/include/cairo"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${pango}/include/pango-1.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${atk}/include/atk-1.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gdk_pixbuf}/include/gdk-pixbuf-2.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gdk_pixbuf}/lib/gdk-pixbuf-2.0/include"

    export NIX_LDFLAGS="$NIX_LDFLAGS -lnotify"
  '';

  meta = {
    description = "Utility for switching between keyboard layouts";
    homepage = http://xneur.ru;
    license = "GPL2+";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
