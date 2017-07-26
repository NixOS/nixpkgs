{ stdenv, fetchurl, libsoup, graphicsmagick, SDL, json_glib
, GConf, atk, cairo, cmake, curl, dbus_glib, exiv2, glib
, libgnome_keyring, gtk3, ilmbase, intltool, lcms, lcms2
, lensfun, libXau, libXdmcp, libexif, libglade, libgphoto2, libjpeg
, libpng, libpthreadstubs, librsvg, libtiff, libxcb
, openexr, osm-gps-map, pixman, pkgconfig, sqlite, bash, libxslt, openjpeg
, mesa, lua, pugixml, colord, colord-gtk, libxshmfence, libxkbcommon
, epoxy, at_spi2_core, libwebp, libsecret, wrapGAppsHook, gnome3
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  version = "2.2.5";
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "10gjzd4irxhladh4jyss9kgp627k8vgx2divipsb33pp6cms80z3";
  };

  buildInputs =
    [ GConf atk cairo cmake curl dbus_glib exiv2 glib libgnome_keyring gtk3
      ilmbase intltool lcms lcms2 lensfun libXau libXdmcp libexif
      libglade libgphoto2 libjpeg libpng libpthreadstubs
      librsvg libtiff libxcb openexr pixman pkgconfig sqlite libxslt
      libsoup graphicsmagick SDL json_glib openjpeg mesa lua pugixml
      colord colord-gtk libxshmfence libxkbcommon epoxy at_spi2_core
      libwebp libsecret wrapGAppsHook gnome3.adwaita-icon-theme
      osm-gps-map
    ];

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
  ];

  # darktable changed its rpath handling in commit
  # 83c70b876af6484506901e6b381304ae0d073d3c and as a result the
  # binaries can't find libdarktable.so, so change LD_LIBRARY_PATH in
  # the wrappers:
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ":" "$out/lib/darktable"
    )
  '';

  meta = with stdenv.lib; {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = https://www.darktable.org;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.rickynils maintainers.flosse ];
  };
}
