{ lib, stdenv, fetchurl, libogg, libvorbis, libdvdread }:

stdenv.mkDerivation rec {
  pname = "ogmtools";
  version = "1.5";

  src = fetchurl {
    url = "https://www.bunkus.org/videotools/ogmtools/ogmtools-${version}.tar.bz2";
    sha256 = "1spx81p5wf59ksl3r3gvf78d77sh7gj8a6lw773iv67bphfivmn8";
  };

  buildInputs = [ libogg libvorbis libdvdread ];

  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  meta = {
    description = "Tools for modifying and inspecting OGG media streams";
    longDescription = ''
      These tools allow information about (ogminfo) or extraction from
      (ogmdemux) or creation of (ogmmerge) OGG media streams. Includes dvdxchap
      tool for extracting chapter information from DVD.
    '';
    homepage = "https://www.bunkus.org/videotools/ogmtools/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
