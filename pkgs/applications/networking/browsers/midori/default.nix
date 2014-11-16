{ stdenv, fetchurl, cmake, pkgconfig, intltool, vala, makeWrapper
, gtk3, webkitgtk, librsvg, libnotify
, glib-networking, gsettings_desktop_schemas
}:

let
  version = "0.5.8";
in
stdenv.mkDerivation rec {
  name = "midori-${version}";

  meta = {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = "http://www.midori-browser.org";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ raskin iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/downloads/midori_${version}_all_.tar.bz2";
    sha256 = "10ckm98rfqfbwr84b8mc1ssgj84wjgkr4dadvx2l7c64sigi66dg";
  };

  sourceRoot = ".";

  buildInputs = [
    cmake pkgconfig intltool vala makeWrapper
    webkitgtk librsvg libnotify
  ];

  cmakeFlags = ''
    -DHALF_BRO_INCOM_WEBKIT2=ON
    -DUSE_ZEITGEIST=OFF
  '';

  preFixup = ''
    wrapProgram $out/bin/midori \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';
}
