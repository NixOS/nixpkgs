{ stdenv, fetchurl, libsoup, graphicsmagick, json-glib, wrapGAppsHook
, cairo, cmake, ninja, curl, perl, llvm, desktop-file-utils, exiv2, glib
, ilmbase, gtk3, intltool, lcms2, lensfun, libX11, libexif, libgphoto2, libjpeg
, libpng, librsvg, libtiff, openexr, osm-gps-map, pkgconfig, sqlite, libxslt
, openjpeg, lua, pugixml, colord, colord-gtk, libwebp, libsecret, gnome3
, ocl-icd
}:

stdenv.mkDerivation rec {
  version = "2.4.4";
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "0kdhmiw4wxk2w9v2hms9yk8nl4ymdshnqyj0l07nivzzr6w20hwn";
  };

  nativeBuildInputs = [ cmake ninja llvm pkgconfig intltool perl desktop-file-utils wrapGAppsHook ];

  buildInputs = [
    cairo curl exiv2 glib gtk3 ilmbase lcms2 lensfun libX11 libexif
    libgphoto2 libjpeg libpng librsvg libtiff openexr sqlite libxslt
    libsoup graphicsmagick json-glib openjpeg lua pugixml
    colord colord-gtk libwebp libsecret gnome3.adwaita-icon-theme
    osm-gps-map ocl-icd
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
      --prefix LD_LIBRARY_PATH ":" "$out/lib/darktable:${ocl-icd}/lib"
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
