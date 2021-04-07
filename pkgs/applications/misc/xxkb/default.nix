{ lib, stdenv, fetchurl, libX11, libXt, libXext, libXpm, imake, gccmakedep
, svgSupport ? false, librsvg, glib, gdk-pixbuf, pkg-config
}:

assert svgSupport ->
  librsvg != null && glib != null && gdk-pixbuf != null && pkg-config != null;

stdenv.mkDerivation rec {
  name = "xxkb-1.11.1";

  src = fetchurl {
    url = "mirror://sourceforge/xxkb/${name}-src.tar.gz";
    sha256 = "0hl1i38z9xnbgfjkaz04vv1n8xbgfg88g5z8fyzyb2hxv2z37anf";
  };

  nativeBuildInputs = [ imake gccmakedep ];
  buildInputs = [
    libX11 libXt libXext libXpm
  ] ++ lib.optionals svgSupport [ librsvg glib gdk-pixbuf pkg-config ];

  outputs = [ "out" "man" ];

  imakeFlags = lib.optionalString svgSupport "-DWITH_SVG_SUPPORT";

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "PIXMAPDIR=${placeholder "out"}/share/xxkb"
    "XAPPLOADDIR=${placeholder "out"}/etc/X11/app-defaults"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  installTargets = [ "install" "install.man" ];

  meta = {
    description = "A keyboard layout indicator and switcher";
    homepage = "http://xxkb.sourceforge.net/";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ rasendubi ];
    platforms = lib.platforms.linux;
  };
}
