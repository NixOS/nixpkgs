{ stdenv, fetchurl, gtk2, pkgconfig }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "gwyddion";
  version = "2.48";
  src = fetchurl {
    url = "http://sourceforge.net/projects/gwyddion/files/gwyddion/2.48/gwyddion-2.48.tar.xz";
    sha256 = "119iw58ac2wn4cas6js8m7r1n4gmmkga6b1y711xzcyjp9hshgwx";
  };
  buildInputs = [ gtk2 pkgconfig ];
  meta = {
    homepage = http://gwyddion.net/;

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
    platforms = stdenv.lib.platforms.linux;
  };
}
