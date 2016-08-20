{ stdenv, fetchurl, cmake, pkgconfig, intltool, vala_0_34, wrapGAppsHook
, gtk3, webkitgtk, librsvg, libnotify, sqlite
, glib-networking, gsettings-desktop-schemas, libsoup, pcre, gnome3
, libxcb, libpthreadstubs, libXdmcp, libxkbcommon, epoxy, at-spi2-core
, zeitgeistSupport ? false, zeitgeist ? null
}:

assert zeitgeistSupport -> zeitgeist != null;

stdenv.mkDerivation rec {
  name = "midori-${version}";
  version = "0.5.11";

  meta = with stdenv.lib; {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = http://midori-browser.org;
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
    pkgconfig wrapGAppsHook cmake intltool vala_0_34
  ];

  buildInputs = [
    gtk3 webkitgtk librsvg libnotify sqlite gsettings-desktop-schemas pcre gnome3.gcr
    libxcb libpthreadstubs libXdmcp libxkbcommon epoxy at-spi2-core
    (libsoup.override {gnomeSupport = true; valaSupport = true;})
  ] ++ stdenv.lib.optionals zeitgeistSupport [
    zeitgeist
  ];

  cmakeFlags = {
    USE_ZEITGEIST = zeitgeistSupport;
    HALF_BRO_INCOM_WEBKIT2 = true;
    USE_GTK3 = true;
  };

  NIX_LDFLAGS="-lX11";

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules")
  '';
}
