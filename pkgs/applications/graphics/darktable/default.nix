{ lib
, stdenv
, fetchurl
, libsoup
, graphicsmagick
, json-glib
, wrapGAppsHook
, cairo
, cmake
, ninja
, curl
, perl
, llvm_13
, desktop-file-utils
, exiv2
, glib
, ilmbase
, gtk3
, intltool
, lcms2
, lensfun
, libX11
, libexif
, libgphoto2
, libjpeg
, libpng
, librsvg
, libtiff
, openexr_3
, osm-gps-map
, pkg-config
, sqlite
, libxslt
, openjpeg
, pugixml
, colord
, colord-gtk
, libwebp
, libsecret
, gnome
, SDL2
, ocl-icd
, pcre
, gtk-mac-integration
, isocodes
, llvmPackages
, gmic
, libavif
, icu
, jasper
, libheif
, libaom
, portmidi
, fetchpatch
, lua5_4
, ...
}:

stdenv.mkDerivation rec {
  version = "3.8.0";
  pname = "darktable";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "01gp9dg5wr2rg1k8cqs0l3s7ism8a4q8qypgwccd4jh7ip3wfr9f";
  };

  nativeBuildInputs = [ cmake ninja llvm_13 pkg-config intltool perl desktop-file-utils wrapGAppsHook ];

  buildInputs = [
    cairo
    curl
    exiv2
    glib
    gtk3
    ilmbase
    lcms2
    lensfun
    libexif
    libgphoto2
    libjpeg
    libpng
    librsvg
    libtiff
    openexr_3
    sqlite
    libxslt
    libsoup
    graphicsmagick
    json-glib
    openjpeg
    pugixml
    libwebp
    libsecret
    SDL2
    gnome.adwaita-icon-theme
    osm-gps-map
    pcre
    isocodes
    gmic
    libavif
    icu
    jasper
    libheif
    libaom
    portmidi
    lua5_4
  ] ++ lib.optionals stdenv.isLinux [
    colord
    colord-gtk
    libX11
    ocl-icd
  ] ++ lib.optional stdenv.isDarwin gtk-mac-integration
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DUSE_COLORD=OFF"
    "-DUSE_KWALLET=OFF"
  ];

  patches = [
    (fetchpatch {
      # This is merged in darktable master and will hopefully be in 3.8.1
      name = "cmake-fix.patch";
      url = "https://github.com/darktable-org/darktable/commit/58d247f7ebea76c55fa2525beb9f5ce092c6670d.patch";
      sha256 = "11fn6d2mwlapbf1zbyv6bhgv29kxcwrs7cnbway0rnl9nj8wimf2";
    })
  ];

  # darktable changed its rpath handling in commit
  # 83c70b876af6484506901e6b381304ae0d073d3c and as a result the
  # binaries can't find libdarktable.so, so change LD_LIBRARY_PATH in
  # the wrappers:
  preFixup =
    let
      libPathEnvVar = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
      libPathPrefix = "$out/lib/darktable" + lib.optionalString stdenv.isLinux ":${ocl-icd}/lib";
    in
    ''
      for f in $out/share/darktable/kernels/*.cl; do
        sed -r "s|#include \"(.*)\"|#include \"$out/share/darktable/kernels/\1\"|g" -i "$f"
      done

      gappsWrapperArgs+=(
        --prefix ${libPathEnvVar} ":" "${libPathPrefix}"
      )
    '';

  meta = with lib; {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = "https://www.darktable.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ goibhniu flosse mrVanDalo paperdigits ];
  };
}
