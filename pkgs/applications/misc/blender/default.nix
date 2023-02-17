{ config, stdenv, lib, fetchurl, fetchzip, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libwebp, libGLU, libGL, openal, opencolorio, openexr, openimagedenoise, openimageio, openjpeg, python310Packages
, openvdb, libXxf86vm, tbb, alembic
, zlib, zstd, fftw, opensubdiv, freetype, jemalloc, ocl-icd, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, cudaSupport ? config.cudaSupport or false, cudaPackages ? {}
, hipSupport ? false, hip # comes with a significantly larger closure size
, colladaSupport ? true, opencollada
, spaceNavSupport ? stdenv.isLinux, libspnav
, makeWrapper
, pugixml, llvmPackages, SDL, Cocoa, CoreGraphics, ForceFeedback, OpenAL, OpenGL
, potrace
, openxr-loader
, embree, gmp, libharu
}:

let
  python = python310Packages.python;
  optix = fetchzip {
    # url taken from the archlinux blender PKGBUILD
    url = "https://developer.download.nvidia.com/redist/optix/v7.3/OptiX-7.3.0-Include.zip";
    sha256 = "0max1j4822mchj0xpz9lqzh91zkmvsn4py0r174cvqfz8z8ykjk8";
  };

in
stdenv.mkDerivation rec {
  pname = "blender";
  version = "3.3.1";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    hash = "sha256-KtpI8L+KDKgCuYfXV0UgEuH48krPTSNFOwnC1ZURjMo=";
  };

  patches = lib.optional stdenv.isDarwin ./darwin.patch;

  nativeBuildInputs = [ cmake makeWrapper python310Packages.wrapPython llvmPackages.llvm.dev ]
    ++ lib.optionals cudaSupport [ addOpenGLRunpath ];
  buildInputs =
    [ boost ffmpeg gettext glew ilmbase
      freetype libjpeg libpng libsamplerate libsndfile libtiff libwebp
      opencolorio openexr openimagedenoise openimageio openjpeg python zlib zstd fftw jemalloc
      alembic
      (opensubdiv.override { inherit cudaSupport; })
      tbb
      embree
      gmp
      pugixml
      potrace
      libharu
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
    ++ lib.optional jackaudioSupport libjack2
    ++ lib.optional cudaSupport cudaPackages.cudatoolkit
    ++ lib.optional colladaSupport opencollada
    ++ lib.optional spaceNavSupport libspnav;
  pythonPath = with python310Packages; [ numpy requests ];

  postPatch = ''
    # allow usage of dynamically linked embree
    rm build_files/cmake/Modules/FindEmbree.cmake
  '' +
    (if stdenv.isDarwin then ''
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
                  '${python310Packages.numpy}/${python.sitePackages}/numpy'
    '' else ''
      substituteInPlace extern/clew/src/clew.c --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
    '') +
    (lib.optionalString hipSupport ''
      substituteInPlace extern/hipew/src/hipew.c --replace '"/opt/rocm/hip/lib/libamdhip64.so"' '"${hip}/lib/libamdhip64.so"'
      substituteInPlace extern/hipew/src/hipew.c --replace '"opt/rocm/hip/bin"' '"${hip}/bin"'
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
      "-DPYTHON_NUMPY_PATH=${python310Packages.numpy}/${python.sitePackages}"
      "-DPYTHON_NUMPY_INCLUDE_DIRS=${python310Packages.numpy}/${python.sitePackages}/numpy/core/include"
      "-DWITH_PYTHON_INSTALL_REQUESTS=OFF"
      "-DWITH_OPENVDB=ON"
      "-DWITH_TBB=ON"
      "-DWITH_IMAGE_OPENJPEG=ON"
      "-DWITH_OPENCOLLADA=${if colladaSupport then "ON" else "OFF"}"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DWITH_CYCLES_OSL=OFF" # requires LLVM
      "-DWITH_OPENVDB=OFF" # OpenVDB currently doesn't build on darwin

      "-DLIBDIR=/does-not-exist"
    ]
    # Clang doesn't support "-export-dynamic"
    ++ lib.optional stdenv.cc.isClang "-DPYTHON_LINKFLAGS="
    ++ lib.optional jackaudioSupport "-DWITH_JACK=ON"
    ++ lib.optionals cudaSupport [
      "-DWITH_CYCLES_CUDA_BINARIES=ON"
      "-DWITH_CYCLES_DEVICE_OPTIX=ON"
      "-DOPTIX_ROOT_DIR=${optix}"
    ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  NIX_LDFLAGS = lib.optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  blenderExecutable =
    placeholder "out" + (if stdenv.isDarwin then "/Applications/Blender.app/Contents/MacOS/Blender" else "/bin/blender");
  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/Blender.app $out/Applications
  '' + ''
    buildPythonPath "$pythonPath"
    wrapProgram $blenderExecutable \
      --prefix PATH : $program_PATH \
      --prefix PYTHONPATH : "$program_PYTHONPATH" \
      --add-flags '--python-use-system-env'
  '';

  # Set RUNPATH so that libcuda and libnvrtc in /run/opengl-driver(-32)/lib can be
  # found. See the explanation in libglvnd.
  postFixup = lib.optionalString cudaSupport ''
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
