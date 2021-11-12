{ automake
, cmake
, exiv2
, expat
, fetchFromGitHub
, fftw
, fftwFloat
, gettext
, glib
, gobject-introspection
, gtkmm2
, lcms2
, lensfun
, libexif
, libiptcdata
, libjpeg
, libraw
, libtiff
, libxml2
, ninja
, openexr
, pcre
, pkg-config
, pugixml
, lib, stdenv
, swig
, vips
}:

stdenv.mkDerivation rec {
  pname = "photoflow";
  version = "2020-08-28";

  src = fetchFromGitHub {
    owner = "aferrero2707";
    repo = pname;
    rev = "8472024fb91175791e0eb23c434c5b58ecd250eb";
    sha256 = "1bq4733hbh15nwpixpyhqfn3bwkg38amdj2xc0my0pii8l9ln793";
  };

  patches = [ ./CMakeLists.patch ];

  nativeBuildInputs = [
    automake
    cmake
    gettext
    glib
    gobject-introspection
    libxml2
    ninja
    pkg-config
    swig
  ];

  buildInputs = [
    exiv2
    expat
    fftw
    fftwFloat
    gtkmm2  # Could be build with gtk3 but proper UI theme is missing and therefore not very usable with gtk3
            # See: https://discuss.pixls.us/t/help-needed-for-gtk3-theme/5803
    lcms2
    lensfun
    libexif
    libiptcdata
    libjpeg
    libraw
    libtiff
    openexr
    pcre
    pugixml
    vips
  ];

  cmakeFlags = [
    "-DBUNDLED_EXIV2=OFF"
    "-DBUNDLED_LENSFUN=OFF"
    "-DBUNDLED_GEXIV2=OFF"
  ];

  meta = with lib; {
    description = "A fully non-destructive photo retouching program providing a complete RAW image editing workflow";
    homepage = "https://aferrero2707.github.io/PhotoFlow/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.MtP ];
    platforms = platforms.linux;
    # sse3 is not supported on aarch64
    badPlatforms = [ "aarch64-linux" ];
    # added 2021-09-30
    # upstream seems pretty dead
    #/build/source/src/operations/denoise.cc:30:10: fatal error: vips/cimg_funcs.h: No such file or directory
    broken = true;
  };
}
