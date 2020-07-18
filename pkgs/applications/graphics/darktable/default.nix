{ stdenv, fetchurl, libsoup, graphicsmagick, json-glib, wrapGAppsHook
, cairo, cmake, ninja, curl, perl, llvm, desktop-file-utils, exiv2, glib
, ilmbase, gtk3, intltool, lcms2, lensfun, libX11, libexif, libgphoto2, libjpeg
, libpng, librsvg, libtiff, openexr, osm-gps-map, pkgconfig, sqlite, libxslt
, openjpeg, lua, pugixml, colord, colord-gtk, libwebp, libsecret, gnome3
, ocl-icd, pcre, gtk-mac-integration, isocodes, llvmPackages
}:

stdenv.mkDerivation rec {
  version = "3.0.2";
  pname = "darktable";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "1yrnkw8c47kmy2x6m1xp69hwyk02xyc8pd9kvcmyj54lzrhzdfka";
  };

  nativeBuildInputs = [ cmake ninja llvm pkgconfig intltool perl desktop-file-utils wrapGAppsHook ];

  buildInputs = [
    cairo curl exiv2 glib gtk3 ilmbase lcms2 lensfun libexif
    libgphoto2 libjpeg libpng librsvg libtiff openexr sqlite libxslt
    libsoup graphicsmagick json-glib openjpeg lua pugixml
    libwebp libsecret gnome3.adwaita-icon-theme osm-gps-map pcre isocodes
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    colord colord-gtk libX11 ocl-icd
  ] ++ stdenv.lib.optional stdenv.isDarwin gtk-mac-integration
    ++ stdenv.lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DUSE_COLORD=OFF"
    "-DUSE_KWALLET=OFF"
  ];


  # darktable changed its rpath handling in commit
  # 83c70b876af6484506901e6b381304ae0d073d3c and as a result the
  # binaries can't find libdarktable.so, so change LD_LIBRARY_PATH in
  # the wrappers:
  preFixup = let
    libPathEnvVar = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    libPathPrefix = "$out/lib/darktable" + stdenv.lib.optionalString stdenv.isLinux ":${ocl-icd}/lib";
  in ''
    for f in $out/share/darktable/kernels/*.cl; do
      sed -r "s|#include \"(.*)\"|#include \"$out/share/darktable/kernels/\1\"|g" -i "$f"
    done

    gappsWrapperArgs+=(
      --prefix ${libPathEnvVar} ":" "${libPathPrefix}"
    )
  '';

  meta = with stdenv.lib; {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = "https://www.darktable.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ goibhniu flosse mrVanDalo ];
  };
}
