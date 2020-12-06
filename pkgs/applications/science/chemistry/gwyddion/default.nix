{ stdenv, fetchurl, gtk2, pkg-config, fftw, file,
  pythonSupport ? false, pythonPackages ? null,
  gnome2 ? null,
  openexrSupport ? true, openexr ? null,
  libzipSupport ? true, libzip ? null,
  libxml2Support ? true, libxml2 ? null,
  libwebpSupport ? true, libwebp ? null,
  # libXmu is not used if libunique is.
  libXmuSupport ? false, xorg ? null,
  libxsltSupport ? true, libxslt ? null,
  fitsSupport ? true, cfitsio ? null,
  zlibSupport ? true, zlib ? null,
  libuniqueSupport ? true, libunique ? null,
  libpngSupport ? true, libpng ? null,
  openglSupport ? !stdenv.isDarwin
}:

assert openexrSupport -> openexr != null;
assert libzipSupport -> libzip != null;
assert libxml2Support -> libxml2 != null;
assert libwebpSupport -> libwebp != null;
assert libXmuSupport -> xorg != null;
assert libxsltSupport -> libxslt != null;
assert fitsSupport -> cfitsio != null;
assert zlibSupport -> zlib != null;
assert libuniqueSupport -> libunique != null;
assert libpngSupport -> libpng != null;
assert openglSupport -> gnome2 != null;
assert pythonSupport -> (pythonPackages != null && gnome2 != null);

let
    inherit (pythonPackages) pygtk pygobject2 python;

in

stdenv.mkDerivation rec {
  pname = "gwyddion";
   version = "2.56";
  src = fetchurl {
    url = "mirror://sourceforge/gwyddion/gwyddion-${version}.tar.xz";
    sha256 = "0z83p3ifdkv5dds8s6fqqbycql1zmgppdc7ygqmm12z5zlrl9p12";
  };
  
  nativeBuildInputs = [ pkg-config file ];
  
  buildInputs = with stdenv.lib;
    [ gtk2 fftw ] ++
    optional openglSupport gnome2.gtkglext ++
    optional openexrSupport openexr ++
    optional libXmuSupport xorg.libXmu ++
    optional fitsSupport cfitsio ++
    optional libpngSupport libpng ++
    optional libxsltSupport libxslt ++
    optional libxml2Support libxml2 ++
    optional libwebpSupport libwebp ++
    optional zlibSupport zlib ++
    optional libuniqueSupport libunique ++
    optional libzipSupport libzip;

  propagatedBuildInputs = with stdenv.lib;
    optionals pythonSupport [ pygtk pygobject2 python gnome2.gtksourceview ];

  # This patch corrects problems with python support, but should apply cleanly
  # regardless of whether python support is enabled, and have no effects if
  # it is disabled.
  patches = [ ./codegen.patch ];
  meta = {
    homepage = "http://gwyddion.net/";

    description = "Scanning probe microscopy data visualization and analysis";

    longDescription = ''
      A modular program for SPM (scanning probe microscopy) data
      visualization and analysis. Primarily it is intended for the
      analysis of height fields obtained by scanning probe microscopy
      techniques (AFM, MFM, STM, SNOM/NSOM) and it supports a lot of
      SPM data formats. However, it can be used for general height
      field and (greyscale) image processing, for instance for the
      analysis of profilometry data or thickness maps from imaging
      spectrophotometry.
    '';
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = [ stdenv.lib.maintainers.cge ];
  };
}
