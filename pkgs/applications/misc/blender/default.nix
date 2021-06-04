{ config, stdenv, lib, fetchurl, fetchzip, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libGLU, libGL, openal, opencolorio, openexr, openimagedenoise, openimageio2, openjpeg, python39Packages
, openvdb, libXxf86vm, tbb, alembic
, zlib, fftw, opensubdiv, freetype, jemalloc, ocl-icd, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, colladaSupport ? true, opencollada
, spaceNavSupport ? stdenv.isLinux, libspnav
, makeWrapper
, pugixml, llvmPackages, SDL, Cocoa, CoreGraphics, ForceFeedback, OpenAL, OpenGL
, potrace
, openxr-loader
, embree, gmp
}:

with lib;
let
  python = python39Packages.python;
  optix = fetchzip {
    url = "https://developer.download.nvidia.com/redist/optix/v7.0/OptiX-7.0.0-include.zip";
    sha256 = "1b3ccd3197anya2bj3psxdrvrpfgiwva5zfv2xmyrl73nb2dvfr7";
  };

in
stdenv.mkDerivation rec {
  pname = "blender";
  version = "2.93.0";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    sha256 = "0f2rpqa39sir6g90khd2d2fs4kss0zhk7vya1nscf5yp8r566fxs";
  };

  patches = lib.optional stdenv.isDarwin ./darwin.patch;

  nativeBuildInputs = [ cmake makeWrapper python39Packages.wrapPython llvmPackages.llvm.dev ]
    ++ optionals cudaSupport [ addOpenGLRunpath ];
  buildInputs =
    [ boost ffmpeg gettext glew ilmbase
      freetype libjpeg libpng libsamplerate libsndfile libtiff
      opencolorio openexr openimagedenoise openimageio2 openjpeg python zlib fftw jemalloc
      alembic
      (opensubdiv.override { inherit cudaSupport; })
      tbb
      embree
      gmp
      pugixml
      potrace
    ]
    ++ (if (!stdenv.isDarwin) then [
      libXi libX11 libXext libXrender
      libGLU libGL openal
      libXxf86vm
      openxr-loader
      # OpenVDB currently doesn't build on darwin
      openvdb
    ]
    else [
      llvmPackages.openmp SDL Cocoa CoreGraphics ForceFeedback OpenAL OpenGL
    ])
    ++ optional jackaudioSupport libjack2
    ++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada
    ++ optional spaceNavSupport libspnav;
  pythonPath = with python39Packages; [ numpy requests ];

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
        --replace '${"$"}{LIBDIR}/python' \
                  '${python}' \
        --replace '${"$"}{LIBDIR}/opencollada' \
                  '${opencollada}' \
        --replace '${"$"}{PYTHON_LIBPATH}/site-packages/numpy' \
                  '${python39Packages.numpy}/${python.sitePackages}/numpy'
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
      "-DPYTHON_NUMPY_PATH=${python39Packages.numpy}/${python.sitePackages}"
      "-DPYTHON_NUMPY_INCLUDE_DIRS=${python39Packages.numpy}/${python.sitePackages}/numpy/core/include"
      "-DWITH_PYTHON_INSTALL_REQUESTS=OFF"
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
  postInstall = ''
    buildPythonPath "$pythonPath"
    wrapProgram $blenderExecutable \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
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
