{ stdenv, fetchurl, cmake, pkgconfig, intltool, vala, makeWrapper
, gtk3, webkitgtk, librsvg, libnotify
, glib_networking, gsettings_desktop_schemas
}:

stdenv.mkDerivation rec {
  name = "midori-0.5.6";

  meta = {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = "http://www.midori-browser.org";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ raskin iyzsong ];
  };

  src = fetchurl {
    url = "${meta.homepage}/downloads/midori_0.5.6_all_.tar.bz2";
    sha256 = "0jpj8cw0dzamzylzslayamjhv0is0xd99dyaql4nyxrkk5fipgn5";
  };

  buildInputs = [
    cmake pkgconfig intltool vala makeWrapper
    webkitgtk librsvg libnotify
  ];

  cmakeFlags = ''
    -DHALF_BRO_INCOM_WEBKIT2=ON
    -DUSE_ZEITGEIST=OFF
  '';

  postInstall = ''
    wrapProgram $out/bin/midori \
      --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share:${gsettings_desktop_schemas}/share"
  '';
}
