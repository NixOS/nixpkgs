{ stdenv, fetchurl, SDL, boost, cmake, ffmpeg, gettext, glew
, ilmbase, jackaudio, libXi, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, mesa, openal, opencolorio, openexr, openimageio, openjpeg, python
, zlib
}:

stdenv.mkDerivation rec {
  name = "blender-2.67";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "066lwrm85455gs187bxr3jhqidc2f6f0791b4216jkagbszd9a8l";
  };

  buildInputs = [
    SDL boost cmake ffmpeg gettext glew ilmbase jackaudio libXi
    libjpeg libpng libsamplerate libsndfile libtiff mesa openal
    opencolorio openexr openimageio openjpeg python zlib
  ];


  cmakeFlags = [
    "-DOPENEXR_INC=${openexr}/include/OpenEXR"
    "-DWITH_OPENCOLLADA=OFF"
    "-DWITH_CODEC_FFMPEG=ON"
    "-DWITH_CODEC_SNDFILE=ON"
    "-DWITH_JACK=ON"
    "-DWITH_INSTALL_PORTABLE=OFF"
    "-DPYTHON_LIBRARY=python${python.majorVersion}m"    
    "-DPYTHON_LIBPATH=${python}/lib"
    "-DPYTHON_INCLUDE_DIR=${python}/include/python${python.majorVersion}m"
  ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR -I${python}/include/${python.libPrefix}m";

  enableParallelBuilding = true;

  meta = {
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = "GPLv2+";
  };
}
