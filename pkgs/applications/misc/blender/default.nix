{ config, stdenv, lib, fetchurl, fetchzip, boost, cmake, ffmpeg, gettext, glew
, libepoxy, libXi, libX11, libXext, libXrender
, libjpeg, libpng, libsamplerate, libsndfile
, libtiff, libwebp, libGLU, libGL, openal, opencolorio, openexr, openimagedenoise, openimageio, openjpeg, python310Packages
, openvdb, libXxf86vm, tbb, alembic
, zlib, zstd, fftw, fftwFloat, opensubdiv, freetype, jemalloc, ocl-icd, addOpenGLRunpath
, jackaudioSupport ? false, libjack2
, cudaSupport ? config.cudaSupport, cudaPackages ? { }
, hipSupport ? false, rocmPackages # comes with a significantly larger closure size
, colladaSupport ? true, opencollada
, spaceNavSupport ? stdenv.isLinux, libspnav
, makeWrapper
, pugixml, llvmPackages, SDL, Cocoa, CoreGraphics, ForceFeedback, OpenAL, OpenGL
, waylandSupport ? stdenv.isLinux, pkg-config, wayland, wayland-protocols, libffi, libdecor, libxkbcommon, dbus
, potrace
, openxr-loader
, embree, gmp, libharu
, openpgl
, mesa
, runCommand
, callPackage
}:

let
  pythonPackages = python310Packages;
  inherit (pythonPackages) python;
  buildEnv = callPackage ./wrapper.nix {};
  optix = fetchzip {
    # url taken from the archlinux blender PKGBUILD
    url = "https://developer.download.nvidia.com/redist/optix/v7.3/OptiX-7.3.0-Include.zip";
    sha256 = "0max1j4822mchj0xpz9lqzh91zkmvsn4py0r174cvqfz8z8ykjk8";
  };
  libdecor' = libdecor.overrideAttrs (old: {
    # Blender uses private APIs, need to patch to expose them
    patches = (old.patches or [ ]) ++ [ ./libdecor.patch ];
  });

in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "blender";
  version = "4.0.2";

  src = fetchurl {
    url = "https://download.blender.org/source/${pname}-${version}.tar.xz";
    hash = "sha256-qqDnKdp1kc+/RXcq92NFl32qp7EaCvNdmPkxPiRgd6M=";
  };

  patches = [
    ./draco.patch
  ] ++ lib.optional stdenv.isDarwin ./darwin.patch;

  nativeBuildInputs =
    [ cmake makeWrapper python310Packages.wrapPython llvmPackages.llvm.dev
    ]
    ++ lib.optionals cudaSupport [
      addOpenGLRunpath
      cudaPackages.cuda_nvcc
    ]
    ++ lib.optionals waylandSupport [ pkg-config ];
  buildInputs =
    [ boost ffmpeg gettext glew
      freetype libjpeg libpng libsamplerate libsndfile libtiff libwebp
      opencolorio openexr openimageio openjpeg python zlib zstd fftw fftwFloat jemalloc
      alembic
      (opensubdiv.override { inherit cudaSupport; })
      tbb
      gmp
      pugixml
      potrace
      libharu
      libepoxy
      openpgl
    ]
    ++ lib.optionals waylandSupport [
      wayland wayland-protocols libffi libdecor' libxkbcommon dbus
    ]
    ++ lib.optionals (!stdenv.isAarch64) [
      openimagedenoise
      embree
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
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optional colladaSupport opencollada
    ++ lib.optional spaceNavSupport libspnav;
  pythonPath = with python310Packages; [ numpy requests zstandard ];

  postPatch = ''
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
      substituteInPlace extern/hipew/src/hipew.c --replace '"/opt/rocm/hip/lib/libamdhip64.so"' '"${rocmPackages.clr}/lib/libamdhip64.so"'
      substituteInPlace extern/hipew/src/hipew.c --replace '"opt/rocm/hip/bin"' '"${rocmPackages.clr}/bin"'
    '');

  cmakeFlags =
    [
      "-DWITH_ALEMBIC=ON"
      # Blender supplies its own FindAlembic.cmake (incompatible with the Alembic-supplied config file)
      "-DALEMBIC_INCLUDE_DIR=${lib.getDev alembic}/include"
      "-DALEMBIC_LIBRARY=${lib.getLib alembic}/lib/libAlembic.so"
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
    ++ lib.optionals waylandSupport [
      "-DWITH_GHOST_WAYLAND=ON"
      "-DWITH_GHOST_WAYLAND_DBUS=ON"
      "-DWITH_GHOST_WAYLAND_DYNLOAD=OFF"
      "-DWITH_GHOST_WAYLAND_LIBDECOR=ON"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      "-DWITH_CYCLES_EMBREE=OFF"
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

  env.NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}";

  # Since some dependencies are built with gcc 6, we need gcc 6's
  # libstdc++ in our RPATH. Sigh.
  NIX_LDFLAGS = lib.optionalString cudaSupport "-rpath ${stdenv.cc.cc.lib}/lib";

  blenderExecutable =
    placeholder "out" + (if stdenv.isDarwin then "/Applications/Blender.app/Contents/MacOS/Blender" else "/bin/blender");
  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    mv $out/Blender.app $out/Applications
  '' + ''
    mv $out/share/blender/${lib.versions.majorMinor version}/python{,-ext}
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

  passthru = {
    inherit python pythonPackages;

    withPackages = f: let packages = f pythonPackages; in buildEnv.override { blender = finalAttrs.finalPackage; extraModules = packages; };

    tests = {
      render = runCommand "${pname}-test" { } ''
        set -euo pipefail

        export LIBGL_DRIVERS_PATH=${mesa.drivers}/lib/dri
        export __EGL_VENDOR_LIBRARY_FILENAMES=${mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json

        cat <<'PYTHON' > scene-config.py
        import bpy
        bpy.context.scene.eevee.taa_render_samples = 32
        bpy.context.scene.cycles.samples = 32
        if ${if stdenv.isAarch64 then "True" else "False"}:
            bpy.context.scene.cycles.use_denoising = False
        bpy.context.scene.render.resolution_x = 100
        bpy.context.scene.render.resolution_y = 100
        bpy.context.scene.render.threads_mode = 'FIXED'
        bpy.context.scene.render.threads = 1
        PYTHON

        mkdir $out
        for engine in BLENDER_EEVEE CYCLES; do
          echo "Rendering with $engine..."
          # Beware that argument order matters
          ${finalAttrs.finalPackage}/bin/blender \
            --background \
            -noaudio \
            --factory-startup \
            --python-exit-code 1 \
            --python scene-config.py \
            --engine "$engine" \
            --render-output "$out/$engine" \
            --render-frame 1
        done
      '';
    };
  };

  meta = with lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    # OptiX, enabled with cudaSupport, is non-free.
    license = with licenses; [ gpl2Plus ] ++ optional cudaSupport unfree;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ goibhniu veprbl ];
    mainProgram = "blender";
  };
})
