{ stdenv, fetchurl, SDL, cmake, gettext, ilmbase, libXi, libjpeg,
libpng, libsamplerate, libtiff, mesa, openal, openexr, openjpeg,
python, zlib, boost }:

stdenv.mkDerivation rec {
  name = "blender-2.63a";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "c479b1abfe5fd8a1a5d04b8d21fdbc0fc960d7855b24785b888c09792bca4c1a";
  };

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal
    SDL openexr libsamplerate libXi libtiff ilmbase openjpeg boost ];

  cmakeFlags = [
    "-DOPENEXR_INC=${openexr}/include/OpenEXR"
    "-DWITH_OPENCOLLADA=OFF"
    "-DWITH_INSTALL_PORTABLE=OFF"
    "-DPYTHON_LIBPATH=${python}/lib"
  ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  enableParallelBuilding = true;

  meta = {
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };
}
