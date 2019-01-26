{ stdenv, fetchFromGitHub, gettext, glib, libxml2, pkgconfig, swig, automake, gobject-introspection, cmake, ninja, libtiff, libjpeg, fftw, exiv2, lensfun, gtkmm2, libraw, lcms2, libexif, vips, expat, pcre, pugixml }:

stdenv.mkDerivation {
  name = "photoflow-unstable-2018-08-28";

  src = fetchFromGitHub {
    owner = "aferrero2707";
    repo = "PhotoFlow";
    rev = "df03f2538ddd232e693c307db4ab63eb5bdfea38";
    sha256 = "08ybhv08h24y4li8wb4m89xgrz1szlwpksf6vjharp8cznn4y4x9";
  };

  nativeBuildInputs = [
    gettext
    glib
    libxml2
    pkgconfig
    swig
    automake
    gobject-introspection
    cmake
    ninja
  ];

  buildInputs = [
    libtiff
    libjpeg
    fftw
    exiv2
    lensfun
    gtkmm2  # Could be build with gtk3 but proper UI theme is missing and therefore not very usable with gtk3
            # See: https://discuss.pixls.us/t/help-needed-for-gtk3-theme/5803
    libraw
    lcms2
    libexif
    vips
    expat
    pcre
    pugixml
  ];

  cmakeFlags = [
    "-DBUNDLED_EXIV2=OFF"
    "-DBUNDLED_LENSFUN=OFF"
    "-DBUNDLED_GEXIV2=OFF"
  ];

  meta = with stdenv.lib; {
    description = "A fully non-destructive photo retouching program providing a complete RAW image editing workflow";
    homepage = https://aferrero2707.github.io/PhotoFlow/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.MtP ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
