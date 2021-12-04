{ stdenv, lib, config, fetchzip, fetchurl, cmake, makeWrapper
# Common:
, alembic, boost, embree, ffmpeg, fftw, freetype, gettext
, glew, gmp, ilmbase, jemalloc, libharu, libjpeg, libpng
, libsamplerate, libsndfile, libtiff, opencolorio, openexr
, openimagedenoise, openimageio2, openjpeg, opensubdiv
, potrace, pugixml, python3, tbb, zlib

# Linux specific:
, libGL, libGLU, libX11, libXext, libXi, libXrender, libXxf86vm
, openxr-loader, openvdb, openal, ocl-icd

# Darwin specific:
, Cocoa, CoreGraphics, ForceFeedback, llvmPackages, OpenAL, OpenGL, SDL

# Optional:
, jackaudioSupport ? false
, libjack2

, cudaSupport ? config.cudaSupport or false
, cudatoolkit, addOpenGLRunpath

, colladaSupport ? true
, opencollada

, spaceNavSupport ? stdenv.isLinux
, libspnav
}:

let
  optix = fetchzip {
    # As a reference check the URL against this package in the ArchLinux repo
    # and against what OpenShadingLanguage has in its github workflows
    url = "https://developer.download.nvidia.com/redist/optix/v7.0/OptiX-7.0.0-include.zip";
    sha256 = "1b3ccd3197anya2bj3psxdrvrpfgiwva5zfv2xmyrl73nb2dvfr7";
  };

  numpyPath = "${python3.pkgs.numpy}/${python3.sitePackages}";
in
stdenv.mkDerivation rec {
  pname = "blender";
  version = "2.93.5";

  # We use fetchurl here instead of fetchzip,
  # so that source is available at the https://tarballs.nixos.org
  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    sha256 = "1fsw8w80h8k5w4zmy659bjlzqyn5i198hi1kbpzfrdn8psxg2bfj";
  };

  patches = lib.optionals stdenv.isDarwin [ ./darwin.patch ];

  nativeBuildInputs = [
    cmake makeWrapper python3.pkgs.wrapPython llvmPackages.llvm.dev
  ]
  ++ lib.optionals cudaSupport [ addOpenGLRunpath ];

  buildInputs = [
    alembic boost embree ffmpeg fftw freetype gettext glew
    gmp ilmbase jemalloc libharu libjpeg libpng libsamplerate
    libsndfile libtiff opencolorio openexr openimagedenoise
    openimageio2 openjpeg potrace pugixml python3 tbb zlib
    (opensubdiv.override { inherit cudaSupport; })
  ]
  ++ lib.optionals stdenv.isLinux [
    libGL libGLU libX11 libXext libXi libXrender libXxf86vm
    openal openxr-loader
    # OpenVDB currently doesn't build on darwin
    openvdb
  ]
  ++ lib.optionals stdenv.isDarwin [
    llvmPackages.openmp Cocoa CoreGraphics ForceFeedback SDL
    OpenAL OpenGL
  ]
  ++ lib.optionals jackaudioSupport [ libjack2 ]
  ++ lib.optionals cudaSupport [ cudatoolkit ]
  ++ lib.optionals colladaSupport [ opencollada ]
  ++ lib.optionals spaceNavSupport [ libspnav ];

  pythonPath = with python3.pkgs; [ numpy requests ];

  postPatch = ''
    # allow usage of dynamically linked embree
    rm build_files/cmake/Modules/FindEmbree.cmake
  ''
  + lib.optionalString stdenv.isDarwin ''
    : > build_files/cmake/platform/platform_apple_xcode.cmake
    substituteInPlace source/creator/CMakeLists.txt \
      --replace '${"$"}{LIBDIR}/python' ${python3} \
      --replace '${"$"}{LIBDIR}/openmp' ${llvmPackages.openmp}
    substituteInPlace build_files/cmake/platform/platform_apple.cmake \
      --replace '${"$"}{LIBDIR}/python' ${python3} \
      --replace '${"$"}{LIBDIR}/opencollada' ${opencollada} \
      --replace '${"$"}{PYTHON_LIBPATH}/site-packages/numpy' ${numpyPath}/numpy
  ''
  + lib.optionalString stdenv.isLinux ''
    substituteInPlace extern/clew/src/clew.c \
      --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
  '';

  cmakeFlags = [
    "-DWITH_INSTALL_PORTABLE=OFF"
    "-DWITH_SDL=OFF"
    "-DWITH_PYTHON_INSTALL=OFF"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
    "-DPYTHON_LIBPATH=${python3}/lib"
    "-DPYTHON_LIBRARY=${python3.libPrefix}"
    "-DPYTHON_NUMPY_INCLUDE_DIRS=${numpyPath}/numpy/core/include"
    "-DPYTHON_NUMPY_PATH=${numpyPath}"
    "-DPYTHON_VERSION=${python3.pythonVersion}"
  ]
  ++ lib.optionals stdenv.isDarwin [
    "-DWITH_CYCLES_OSL=OFF" # requires LLVM
    "-DWITH_OPENVDB=OFF" # OpenVDB currently doesn't build on darwin
    "-DLIBDIR=/does-not-exist"
  ]
  # Clang doesn't support "-export-dynamic"
  ++ lib.optionals stdenv.cc.isClang [ "-DPYTHON_LINKFLAGS=" ]
  ++ lib.optionals jackaudioSupport [ "-DWITH_JACK=ON" ]
  ++ lib.optionals cudaSupport [
    "-DWITH_CYCLES_CUDA_BINARIES=ON"
    "-DWITH_CYCLES_DEVICE_OPTIX=ON"
    "-DOPTIX_ROOT_DIR=${optix}"
  ];

  # Since some dependencies are built with gcc 6, we need gcc 6's libstdc++
  # in our RPATH. Sigh.
  NIX_LDFLAGS = lib.optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  blenderExecutable = placeholder "out" + (
    if stdenv.isDarwin
    then "/Applications/Blender.app/Contents/MacOS/Blender"
    else "/bin/blender"
  );

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

  # Set RUNPATH so that libcuda and libnvrtc in /run/opengl-driver(-32)/lib
  # can be found. See the explanation in libglvnd.
  postFixup = lib.optionalString cudaSupport ''
    for program in $out/bin/blender $out/bin/.blender-wrapped; do
      isELF "$program" || continue
      addOpenGLRunpath "$program"
    done
  '';

  meta = with lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    # They comment two licenses: GPLv2 and Blender License, but they say:
    # "We've decided to cancel the BL offering for an indefinite period."
    # OptiX, enabled with cudaSupport, is non-free.
    license = with licenses; [ gpl2Plus ]
      ++ lib.optionals cudaSupport [ unfree ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ goibhniu veprbl ];
  };
}
