{ stdenv, lib, fetchurl, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, mesa, openal, opencolorio, openexr, openimageio, openjpeg_1, python
, zlib, fftw, opensubdiv, freetype, jemalloc
, jackaudioSupport ? false, libjack2
, cudaSupport ? false, cudatoolkit
, colladaSupport ? true, opencollada
}:

with lib;

stdenv.mkDerivation rec {
  name = "blender-2.78";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "0hfl7q6phydlk8mbkksnqxj004qqad99xkrp5n9wrz9vrcf3x1hp";
  };

  buildInputs =
    [ boost cmake ffmpeg gettext glew ilmbase
      libXi libX11 libXext libXrender
      freetype libjpeg libpng libsamplerate libsndfile libtiff mesa openal
      opencolorio openexr openimageio openjpeg_1 python zlib fftw jemalloc
      (opensubdiv.override { inherit cudaSupport; })
    ]
    ++ optional jackaudioSupport libjack2
    ++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada;

  postUnpack =
    ''
      substituteInPlace */doc/manpage/blender.1.py --replace /usr/bin/python ${python}/bin/python3
    '';

  cmakeFlags =
    [ "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DWITH_FFTW3=ON"
      #"-DWITH_SDL=ON"
      "-DWITH_GAMEENGINE=ON"
      "-DWITH_OPENCOLORIO=ON"
      "-DWITH_SYSTEM_OPENJPEG=ON"
      "-DWITH_PLAYER=ON"
      "-DWITH_OPENSUBDIV=ON"
      "-DPYTHON_LIBRARY=python${python.majorVersion}m"
      "-DPYTHON_LIBPATH=${python}/lib"
      "-DPYTHON_INCLUDE_DIR=${python}/include/python${python.majorVersion}m"
      "-DPYTHON_VERSION=${python.majorVersion}"
      "-DWITH_PYTHON_INSTALL=OFF"
      "-DWITH_PYTHON_INSTALL_NUMPY=OFF"
    ]
    ++ optional jackaudioSupport "-DWITH_JACK=ON"
    ++ optional cudaSupport "-DWITH_CYCLES_CUDA_BINARIES=ON"
    ++ optional colladaSupport "-DWITH_OPENCOLLADA=ON";

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}m";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = http://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
