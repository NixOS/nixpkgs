{ config, stdenv, lib, fetchurl, boost, cmake, ffmpeg, gettext, glew
, ilmbase, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libGLU, libGL, openal, opencolorio, openexr, openimageio, openjpeg_1, python3Packages
, openvdb, libXxf86vm, tbb
, zlib, fftw, opensubdiv, freetype, jemalloc, ocl-icd, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, colladaSupport ? true, opencollada
, enableNumpy ? false, makeWrapper
}:

with lib;

let python = python3Packages.python; in

stdenv.mkDerivation rec {
  pname = "blender";
  version = "2.81a";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    sha256 = "1zl0ar95qkxsrbqw9miz2hrjijlqjl06vg3clfk9rm7krr2l3b2j";
  };

  nativeBuildInputs = [ cmake ] ++ optional cudaSupport addOpenGLRunpath;
  buildInputs =
    [ boost ffmpeg gettext glew ilmbase
      libXi libX11 libXext libXrender
      freetype libjpeg libpng libsamplerate libsndfile libtiff libGLU libGL openal
      opencolorio openexr openimageio openjpeg_1 python zlib fftw jemalloc
      (opensubdiv.override { inherit cudaSupport; })
      openvdb libXxf86vm tbb
      makeWrapper
    ]
    ++ optional jackaudioSupport libjack2
    ++ optional cudaSupport cudatoolkit
    ++ optional colladaSupport opencollada;

  postPatch =
    ''
      substituteInPlace extern/clew/src/clew.c --replace '"libOpenCL.so"' '"${ocl-icd}/lib/libOpenCL.so"'
    '';

  cmakeFlags =
    [ "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DWITH_FFTW3=ON"
      #"-DWITH_SDL=ON"
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
    ]
    ++ optional jackaudioSupport "-DWITH_JACK=ON"
    ++ optional cudaSupport "-DWITH_CYCLES_CUDA_BINARIES=ON"
    ++ optional colladaSupport "-DWITH_OPENCOLLADA=ON";

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR -I${python}/include/${python.libPrefix}";

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  NIX_LDFLAGS = optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  enableParallelBuilding = true;

  postInstall = optionalString enableNumpy
    ''
      wrapProgram $out/bin/blender \
        --prefix PYTHONPATH : ${python3Packages.numpy}/${python.sitePackages}
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
    homepage = https://www.blender.org;
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.goibhniu ];
  };
}
