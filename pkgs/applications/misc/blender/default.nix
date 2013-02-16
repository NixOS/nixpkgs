{ stdenv, fetchurl, SDL, cmake, gettext, ilmbase, libXi, libjpeg,
libpng, libsamplerate, libtiff, mesa, openal, openexr, openjpeg,
python, zlib, boost, glew, xlibs }:

stdenv.mkDerivation rec {
  name = "blender-2.65a";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "1p7nszbqsn48s6jrj0bqav7q52gj82rpv1w5lhh64v092m3v9jpq";
  };

  buildInputs = [ cmake mesa gettext python libjpeg libpng zlib openal
    SDL openexr libsamplerate libXi libtiff ilmbase openjpeg boost glew xlibs.libXxf86vm ];

  patches = [ ./fix-include.patch ];

  cmakeFlags = [
    "-DOPENEXR_INC=${openexr}/include/OpenEXR"
    "-DWITH_OPENCOLLADA=OFF"
    "-DWITH_INSTALL_PORTABLE=OFF"
    "-DPYTHON_LIBRARY=${python}/lib"
    "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}"
    "-DOPENJPEG_INCLUDE_DIR=${openjpeg}/include"
    "-DWITH_CYCLES=0" # would need openimageio
  ]; # ToDo?: more options available

  NIX_CFLAGS_COMPILE = "-I${openjpeg}/include/${openjpeg.incDir} -I${ilmbase}/include/OpenEXR";
  NIX_CFLAGS_LINK = "-lpython3";

  enableParallelBuilding = true;

  meta = {
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };
}
