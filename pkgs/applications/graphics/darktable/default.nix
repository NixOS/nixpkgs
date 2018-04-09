{ stdenv, fetchurl, libsoup, graphicsmagick, json-glib, wrapGAppsHook
, cairo, cmake, ninja, curl, perl, llvm, desktop-file-utils, exiv2, glib
, ilmbase, gtk3, intltool, lcms2, lensfun, libX11, libexif, libgphoto2, libjpeg
, libpng, librsvg, libtiff, openexr, osm-gps-map, pkgconfig, sqlite, libxslt
, openjpeg, lua, pugixml, colord, colord-gtk, libwebp, libsecret, gnome3
}:

stdenv.mkDerivation rec {
  version = "2.4.2";
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "10asz918kv2248px3w9bn5k8cfrad5xrci58x9y61l0yf5hcpk0r";
  };

  nativeBuildInputs = [ cmake ninja llvm pkgconfig intltool perl desktop-file-utils wrapGAppsHook ];

  buildInputs = [
    cairo curl exiv2 glib gtk3 ilmbase lcms2 lensfun libX11 libexif
    libgphoto2 libjpeg libpng librsvg libtiff openexr sqlite libxslt
    libsoup graphicsmagick json-glib openjpeg lua pugixml
    colord colord-gtk libwebp libsecret gnome3.adwaita-icon-theme
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
    maintainers = with maintainers; [ goibhniu rickynils flosse mrVanDalo ];
  };
}
