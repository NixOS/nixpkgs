{ config, stdenv, lib, fetchurl, fetchzip, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libGLU, libGL, openal, opencolorio, openexr, openimagedenoise, openimageio2, openjpeg, python3Packages
, openvdb, libXxf86vm, tbb, alembic
, zlib, fftw, opensubdiv, freetype, jemalloc, ocl-icd, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, colladaSupport ? true, opencollada
, makeWrapper
, pugixml, llvmPackages, SDL, Cocoa, CoreGraphics, ForceFeedback, OpenAL, OpenGL
, embree, gmp
}:

with lib;
let
  python = python3Packages.python;
  optix = fetchzip {
    url = "https://developer.download.nvidia.com/redist/optix/v7.0/OptiX-7.0.0-include.zip";
    sha256 = "1b3ccd3197anya2bj3psxdrvrpfgiwva5zfv2xmyrl73nb2dvfr7";
  };

in
stdenv.mkDerivation rec {
  pname = "blender";
  version = "2.91.0";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    sha256 = "0x396lgmk0dq9115yrc36s8zwxzmjr490sr5n2y6w27y17yllyjm";
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
      embree
      gmp
    ]
    ++ (if (!stdenv.isDarwin) then [
      libXi libX11 libXext libXrender
      libGLU libGL openal
      libXxf86vm
      # OpenVDB currently doesn't build on darwin
      openvdb
    ]
    else [
      pugixml llvmPackages.openmp SDL Cocoa CoreGraphics ForceFeedback OpenAL OpenGL
    ])
    ++ optional jackaudioSupport libjack2
    ++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada;

  postPatch = ''
    # allow usage of dynamically linked embree
    rm build_files/cmake/Modules/FindEmbree.cmake
  '' +
    (if stdenv.isDarwin then ''
      : > build_files/cmake/platform/platform_apple_xcode.cmake
      substituteInPlace source/creator/CMakeLists.txt \
        --replace '${"$"}{LIBDIR}/python' \
                  '${python}' \
        --replace '${"$"}{LIBDIR}/openmp' \
                  '${llvmPackages.openmp}'
      substituteInPlace build_files/cmake/platform/platform_apple.cmake \
        --replace 'set(PYTHON_VERSION 3.7)' \
                  'set(PYTHON_VERSION ${python.pythonVersion})' \
        --replace '${"$"}{PYTHON_VERSION}m' \
                  '${"$"}{PYTHON_VERSION}' \
        --replace '${"$"}{LIBDIR}/python' \
                  '${python}' \
        --replace '${"$"}{LIBDIR}/opencollada' \
                  '${opencollada}' \
        --replace '${"$"}{PYTHON_LIBPATH}/site-packages/numpy' \
                  '${python3Packages.numpy}/${python.sitePackages}/numpy'
    '' else ''
      substituteInPlace extern/clew/src/clew.c --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
    '');

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
      "-DPYTHON_LIBRARY=${python.libPrefix}"
      "-DPYTHON_LIBPATH=${python}/lib"
      "-DPYTHON_INCLUDE_DIR=${python}/include/${python.libPrefix}"
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
    ++ optional cudaSupport [
      "-DWITH_CYCLES_CUDA_BINARIES=ON"
      "-DWITH_CYCLES_DEVICE_OPTIX=ON"
      "-DOPTIX_ROOT_DIR=${optix}"
    ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  NIX_LDFLAGS = optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

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

  meta = with lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    # OptiX, enabled with cudaSupport, is non-free.
    license = with licenses; [ gpl2Plus ] ++ optional cudaSupport unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ goibhniu veprbl ];
  };
}
