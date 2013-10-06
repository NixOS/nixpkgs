{ stdenv, fetchurl, libogg, libvorbis, libdvdread }:

stdenv.mkDerivation rec {
  name = "ogmtools-1.5";

  src = fetchurl {
    url = "http://www.bunkus.org/videotools/ogmtools/${name}.tar.bz2";
    sha256 = "1spx81p5wf59ksl3r3gvf78d77sh7gj8a6lw773iv67bphfivmn8";
  };

  buildInputs = [libogg libvorbis libdvdread];

  meta = {
    description = "Tools for modifying and inspecting OGG media streams";
    longDescription = ''
      These tools allow information about (ogminfo) or extraction from
      (ogmdemux) or creation of (ogmmerge) OGG media streams. Includes dvdxchap
      tool for extracting chapter information from DVD.
    '';
    homepage = http://www.bunkus.org/videotools/ogmtools/;
    license = "GPLv2";
    platforms = stdenv.lib.platforms.all;
  };
}
