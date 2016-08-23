{ stdenv, fetchurl, cmake, pkgconfig, intltool, vala_0_23, wrapGAppsHook
, gtk3, webkitgtk, librsvg, libnotify, sqlite
, glib_networking, gsettings_desktop_schemas, libsoup, pcre, gnome3
, libxcb, libpthreadstubs, libXdmcp, libxkbcommon, epoxy, at_spi2_core
, zeitgeistSupport ? false, zeitgeist ? null
}:

assert zeitgeistSupport -> zeitgeist != null;

stdenv.mkDerivation rec {
  name = "midori-${version}";
  version = "0.5.11";

  meta = with stdenv.lib; {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = "http://midori-browser.org";
    license = with licenses; [ lgpl21Plus ];
    platforms = with platforms; linux;
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

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook cmake intltool
  ];

  buildInputs = [
    vala_0_23
    gtk3 webkitgtk librsvg libnotify sqlite gsettings_desktop_schemas pcre gnome3.gcr
    libxcb libpthreadstubs libXdmcp libxkbcommon epoxy at_spi2_core
    (libsoup.override {gnomeSupport = true; valaSupport = true;})
  ] ++ stdenv.lib.optionals zeitgeistSupport [
    zeitgeist
  ];

  cmakeFlags = [ 
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_ZEITGEIST=${if zeitgeistSupport then "ON" else "OFF"}"
    "-DHALF_BRO_INCOM_WEBKIT2=ON"
    "-DUSE_GTK3=1"
  ];

  NIX_LDFLAGS="-lX11";

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules")
  '';
}
