{ config, stdenv, lib, fetchurl, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libGLU, libGL, openal, opencolorio, openexr, openimagedenoise, openimageio2, openjpeg, python3Packages
, openvdb, libXxf86vm, tbb, alembic
, zlib, fftw, opensubdiv, freetype, jemalloc, ocl-icd, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, colladaSupport ? true, opencollada
, makeWrapper
, pugixml, SDL, Cocoa, CoreGraphics, ForceFeedback, OpenAL, OpenGL
}:

with lib;

let python = python3Packages.python; in

stdenv.mkDerivation rec {
  pname = "blender";
  version = "2.82a";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    sha256 = "18zbdgas6qf2kmvvlimxgnq7y9kj7hdxcgixrs6fj50x40q01q2d";
  };

  patches = lib.optional stdenv.isDarwin ./darwin.patch;

  nativeBuildInputs = [ cmake ] ++ optional cudaSupport addOpenGLRunpath;
  buildInputs =
    [ boost ffmpeg gettext glew ilmbase
      freetype libjpeg libpng libsamplerate libsndfile libtiff
      opencolorio openexr openimagedenoise openimageio2 openjpeg python zlib fftw jemalloc
      alembic
      (opensubdiv.override { inherit cudaSupport; })
      tbb
      makeWrapper
    ]
    ++ (if (!stdenv.isDarwin) then [
      libXi libX11 libXext libXrender
      libGLU libGL openal
      libXxf86vm
      # OpenVDB currently doesn't build on darwin
      openvdb
    ]
    else [
      pugixml SDL Cocoa CoreGraphics ForceFeedback OpenAL OpenGL
    ])
    ++ optional jackaudioSupport libjack2
    ++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada;

  postPatch =
    if stdenv.isDarwin then ''
      : > build_files/cmake/platform/platform_apple_xcode.cmake
      substituteInPlace source/creator/CMakeLists.txt \
        --replace '${"$"}{LIBDIR}/python' \
                  '${python}'
      substituteInPlace build_files/cmake/platform/platform_apple.cmake \
        --replace '${"$"}{LIBDIR}/python' \
                  '${python}' \
        --replace '${"$"}{LIBDIR}/opencollada' \
                  '${opencollada}' \
        --replace '${"$"}{PYTHON_LIBPATH}/site-packages/numpy' \
                  '${python3Packages.numpy}/${python.sitePackages}/numpy' \
        --replace 'set(OPENJPEG_INCLUDE_DIRS ' \
                  'set(OPENJPEG_INCLUDE_DIRS "'$(echo ${openjpeg.dev}/include/openjpeg-*)'") #' \
        --replace 'set(OPENJPEG_LIBRARIES ' \
                  'set(OPENJPEG_LIBRARIES "${openjpeg}/lib/libopenjp2.dylib") #' \
        --replace 'set(OPENIMAGEIO ' \
                  'set(OPENIMAGEIO "${openimageio2.out}") #' \
        --replace 'set(OPENEXR_INCLUDE_DIRS ' \
                  'set(OPENEXR_INCLUDE_DIRS "${openexr.dev}/include/OpenEXR") #'
    '' else ''
      substituteInPlace extern/clew/src/clew.c --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
    '';

  cmakeFlags =
    [
      "-DWITH_ALEMBIC=ON"
      "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DWITH_FFTW3=ON"
      "-DWITH_SDL=OFF"
      "-DWITH_OPENCOLORIO=ON"
      "-DWITH_OPENSUBDIV=ON"
      "-DPYTHON_LIBRARY=${python.libPrefix}m"
      "-DPYTHON_LIBPATH=${python}/lib"
      "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}m"
      "-DPYTHON_VERSION=${python.pythonVersion}"
      "-DWITH_PYTHON_INSTALL=OFF"
      "-DWITH_PYTHON_INSTALL_NUMPY=OFF"
      "-DPYTHON_NUMPY_PATH=${python3Packages.numpy}/${python.sitePackages}"
      "-DWITH_OPENVDB=ON"
      "-DWITH_TBB=ON"
      "-DWITH_IMAGE_OPENJPEG=ON"
      "-DWITH_OPENCOLLADA=${if colladaSupport then "ON" else "OFF"}"
    ]
    ++ optionals stdenv.isDarwin [
      "-DWITH_CYCLES_OSL=OFF" # requires LLVM
      "-DWITH_OPENVDB=OFF" # OpenVDB currently doesn't build on darwin

      "-DLIBDIR=/does-not-exist"
    ]
    # Clang doesn't support "-export-dynamic"
    ++ optional stdenv.cc.isClang "-DPYTHON_LINKFLAGS="
    ++ optional jackaudioSupport "-DWITH_JACK=ON"
    ++ optional cudaSupport "-DWITH_CYCLES_CUDA_BINARIES=ON";

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  NIX_LDFLAGS = optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  enableParallelBuilding = true;

  blenderExecutable =
    placeholder "out" + (if stdenv.isDarwin then "/Blender.app/Contents/MacOS/Blender" else "/bin/blender");
  # --python-expr is used to workaround https://developer.blender.org/T74304
  postInstall = ''
    wrapProgram $blenderExecutable \
      --prefix PYTHONPATH : ${python3Packages.numpy}/${python.sitePackages} \
      --add-flags '--python-use-system-env'
  '';

  # Set RUNPATH so that libcuda and libnvrtc in /run/opengl-driver(-32)/lib can be
  # found. See the explanation in libglvnd.
  postFixup = optionalString cudaSupport ''
    for program in $out/bin/blender $out/bin/.blender-wrapped; do
      isELF "$program" || continue
      addOpenGLRunpath "$program"
    done
  '';

  meta = with stdenv.lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
