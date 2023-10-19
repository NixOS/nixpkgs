{ lib, stdenv, fetchurl, gtk2, pkg-config, fftw, file,
  pythonSupport ? false, python2Packages,
  gnome2,
  openexrSupport ? true, openexr,
  libzipSupport ? true, libzip,
  libxml2Support ? true, libxml2,
  libwebpSupport ? true, libwebp,
  # libXmu is not used if libunique is.
  libXmuSupport ? false, xorg,
  libxsltSupport ? true, libxslt,
  fitsSupport ? true, cfitsio,
  zlibSupport ? true, zlib,
  libuniqueSupport ? true, libunique,
  libpngSupport ? true, libpng,
  openglSupport ? !stdenv.isDarwin
}:

let
    inherit (python2Packages) pygtk pygobject2 python;
in

stdenv.mkDerivation rec {
  pname = "gwyddion";
   version = "2.63";
  src = fetchurl {
    url = "mirror://sourceforge/gwyddion/gwyddion-${version}.tar.xz";
    sha256 = "sha256-FSs/Dbnr1shEw/W51DhUFPb61tM+0atc6wxY81EiTdM=";
  };

  nativeBuildInputs = [ pkg-config file ];

  buildInputs = with lib;
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

  propagatedBuildInputs = with lib;
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
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = [ lib.maintainers.cge ];
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
