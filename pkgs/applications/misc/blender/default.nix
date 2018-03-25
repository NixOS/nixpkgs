{ stdenv, lib, fetchurl, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libGLU_combined, openal, opencolorio, openexr, openimageio, openjpeg_1, python
, zlib, fftw, opensubdiv, freetype, jemalloc, ocl-icd
, jackaudioSupport ? false, libjack2
, cudaSupport ? false, cudatoolkit
, colladaSupport ? true, opencollada
, xcbuild, llvm, darwin, libiconv
}:

with lib;

stdenv.mkDerivation rec {
  name = "blender-2.79a";

  src = fetchurl {
    url = "http://download.blender.org/source/${name}.tar.gz";
    sha256 = "1mw45mvfk9f0fhn12vp3g2vwqzinrp3by0m3w01wj87h9ri5zkwc";
  };

  buildInputs =
    [ boost cmake ffmpeg gettext glew ilmbase
      libXi libX11 libXext libXrender
      freetype libjpeg libpng libsamplerate libsndfile libtiff libGLU_combined openal
      opencolorio openexr openimageio openjpeg_1 python zlib fftw jemalloc
      (opensubdiv.override { inherit cudaSupport; })
    ]
    ++ optional jackaudioSupport libjack2
    ++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      xcbuild llvm Cocoa Foundation IOKit AppKit Carbon AudioUnit
      AudioToolbox CoreAudio OpenAL libiconv ForceFeedback ]);

  patches = stdenv.lib.optionals stdenv.isDarwin [
    ./clang-const.patch
    ./no-python-install.patch
    ./darwin-find-packages.patch
    ./isfinite.patch
    ./no-export-dynamic.patch
  ];

  postPatch = ''
    substituteInPlace doc/manpage/blender.1.py --replace /usr/bin/python ${python}/bin/python3
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    substituteInPlace extern/clew/src/clew.c --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
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
    ++ optionals cudaSupport
      [ "-DWITH_CYCLES_CUDA_BINARIES=ON"
        # Disable architectures before sm_30 to support new CUDA toolkits.
        "-DCYCLES_CUDA_BINARIES_ARCH=sm_30;sm_35;sm_37;sm_50;sm_52;sm_60;sm_61"
      ]
    ++ optional colladaSupport "-DWITH_OPENCOLLADA=ON"

    ++ optionals stdenv.isDarwin [
      "-DWITH_CXX11=ON"
      "-DWITH_PYTHON_FRAMEWORK=OFF"
    ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}m";

  # blender assumes install location is .dmg on darwin
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/*.app $out/Applications
    rm $out/*.html $out/*.txt
  '';

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  NIX_LDFLAGS = optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  enableParallelBuilding = true;

  dontUseXcbuild = true;

  meta = with stdenv.lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = https://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
