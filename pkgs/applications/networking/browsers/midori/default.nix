{ stdenv, fetchurl, cmake, pkgconfig, intltool, vala, makeWrapper
, gtk3, webkitgtk, librsvg, libnotify, sqlite
, glib_networking, gsettings_desktop_schemas, libsoup, pcre, gnome3
}:

let
  version = "0.5.11";
in
stdenv.mkDerivation rec {
  name = "midori-${version}";

  meta = with stdenv.lib; {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = "http://midori-browser.org";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ramkromberg ];
  };

  src = fetchurl {
    urls = [
      "${meta.homepage}/downloads/midori_${version}_all_.tar.bz2"
      "http://mirrors-ru.go-parts.com/blfs/conglomeration/midori/midori_${version}_all_.tar.bz2"
    ];
    name = "midori_${version}_all_.tar.bz2";
    sha256 = "0gcwqkcyliqz10i33ww3wl02mmfnl7jzl2d493l4l53ipsb1l6cn";
  };

  buildInputs = [
    cmake pkgconfig intltool vala makeWrapper
    webkitgtk librsvg libnotify sqlite gsettings_desktop_schemas pcre gnome3.gcr
    (libsoup.override {gnomeSupport = true; valaSupport = true;})
  ];

  cmakeFlags = [ 
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_ZEITGEIST=OFF"
    "-DHALF_BRO_INCOM_WEBKIT2=OFF"
    "-DUSE_GTK3=1"
  ];

  NIX_LDFLAGS="-lX11";

  preFixup = ''
    wrapProgram $out/bin/midori \
      --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';
}
