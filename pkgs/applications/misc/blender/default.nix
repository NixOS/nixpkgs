{
  Cocoa,
  CoreGraphics,
  ForceFeedback,
  OpenAL,
  OpenGL,
  SDL,
  addDriverRunpath,
  alembic,
  blender,
  boost,
  brotli,
  callPackage,
  cmake,
  colladaSupport ? true,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  dbus,
  embree,
  fetchgit,
  fetchzip,
  ffmpeg,
  fftw,
  fftwFloat,
  freetype,
  gettext,
  glew,
  gmp,
  hipSupport ? false,
  jackaudioSupport ? false,
  jemalloc,
  lib,
  libGL,
  libGLU,
  libX11,
  libXext,
  libXi,
  libXrender,
  libXxf86vm,
  libdecor,
  libepoxy,
  libffi,
  libharu,
  libjack2,
  libjpeg,
  libpng,
  libsamplerate,
  libsndfile,
  libspnav,
  libtiff,
  libwebp,
  libxkbcommon,
  llvmPackages,
  makeWrapper,
  mesa,
  openal,
  opencollada,
  opencolorio,
  openexr,
  openimagedenoise,
  openimageio,
  openjpeg,
  openpgl,
  opensubdiv,
  openvdb,
  openxr-loader,
  pkg-config,
  potrace,
  pugixml,
  python3Packages, # must use instead of python3.pkgs, see https://github.com/NixOS/nixpkgs/issues/211340
  rocmPackages, # comes with a significantly larger closure size
  runCommand,
  spaceNavSupport ? stdenv.isLinux,
  sse2neon,
  stdenv,
  tbb,
  wayland,
  wayland-protocols,
  waylandSupport ? stdenv.isLinux,
  zlib,
  zstd,
}:

let
  python3 = python3Packages.python;
  pyPkgsOpenusd = python3Packages.openusd.override { withOsl = false; };

  libdecor' = libdecor.overrideAttrs (old: {
    # Blender uses private APIs, need to patch to expose them
    patches = (old.patches or [ ]) ++ [ ./libdecor.patch ];
  });

  optix = fetchzip {
    # URL from https://gitlab.archlinux.org/archlinux/packaging/packages/blender/-/commit/333add667b43255dcb011215a2d2af48281e83cf#9b9baac1eb9b72790eef5540a1685306fc43fd6c_30_30
    url = "https://developer.download.nvidia.com/redist/optix/v7.3/OptiX-7.3.0-Include.zip";
    hash = "sha256-aMrp0Uff4c3ICRn4S6zedf6Q4Mc0/duBhKwKgYgMXVU=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "blender";
  version = "4.2.1";

  srcs = [
    (fetchzip {
      name = "source";
      url = "https://download.blender.org/source/blender-${finalAttrs.version}.tar.xz";
      hash = "sha256-+Y4JbzeK+30fO8WdEmvjOeQjm094ofsUhRFXs9mkcxI=";
    })
    (fetchgit {
      name = "assets";
      url = "https://projects.blender.org/blender/blender-assets.git";
      rev = "6864f1832e71a31e1e04f72bb7a5a1f53f0cd01c";
      fetchLFS = true;
      hash = "sha256-vepK0inPMuleAJBSipwoI99nMBBiFaK/eSMHDetEtjY=";
    })
  ];

  postUnpack = ''
    chmod -R u+w *
    rm -r assets/working
    mv assets --target-directory source/release/datafiles/
  '';

  sourceRoot = "source";

  patches = [ ./draco.patch ] ++ lib.optional stdenv.isDarwin ./darwin.patch;

  postPatch =
    (lib.optionalString stdenv.isDarwin ''
      : > build_files/cmake/platform/platform_apple_xcode.cmake
      substituteInPlace source/creator/CMakeLists.txt \
        --replace-fail '${"$"}{LIBDIR}/python' \
                  '${python3}' \
        --replace-fail '${"$"}{LIBDIR}/materialx/' '${python3Packages.materialx}/'
      substituteInPlace build_files/cmake/platform/platform_apple.cmake \
        --replace-fail '${"$"}{LIBDIR}/brotli/lib/libbrotlicommon-static.a' \
                  '${lib.getLib brotli}/lib/libbrotlicommon.dylib' \
        --replace-fail '${"$"}{LIBDIR}/brotli/lib/libbrotlidec-static.a' \
                  '${lib.getLib brotli}/lib/libbrotlidec.dylib'
    '')
    + (lib.optionalString hipSupport ''
      substituteInPlace extern/hipew/src/hipew.c --replace '"/opt/rocm/hip/lib/libamdhip64.so"' '"${rocmPackages.clr}/lib/libamdhip64.so"'
      substituteInPlace extern/hipew/src/hipew.c --replace '"opt/rocm/hip/bin"' '"${rocmPackages.clr}/bin"'
    '');

  env.NIX_CFLAGS_COMPILE = "-I${python3}/include/${python3.libPrefix}";

  cmakeFlags =
    [
      "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}"
      "-DPYTHON_LIBPATH=${python3}/lib"
      "-DPYTHON_LIBRARY=${python3.libPrefix}"
      "-DPYTHON_NUMPY_INCLUDE_DIRS=${python3Packages.numpy}/${python3.sitePackages}/numpy/core/include"
      "-DPYTHON_NUMPY_PATH=${python3Packages.numpy}/${python3.sitePackages}"
      "-DPYTHON_VERSION=${python3.pythonVersion}"
      "-DWITH_ALEMBIC=ON"
      "-DWITH_CODEC_FFMPEG=ON"
      "-DWITH_CODEC_SNDFILE=ON"
      "-DWITH_FFTW3=ON"
      "-DWITH_IMAGE_OPENJPEG=ON"
      "-DWITH_INSTALL_PORTABLE=OFF"
      "-DMaterialX_DIR=${python3Packages.materialx}/lib/cmake/MaterialX"
      "-DWITH_MOD_OCEANSIM=ON"
      "-DWITH_OPENCOLLADA=${if colladaSupport then "ON" else "OFF"}"
      "-DWITH_OPENCOLORIO=ON"
      "-DWITH_OPENSUBDIV=ON"
      "-DWITH_OPENVDB=ON"
      "-DWITH_PYTHON_INSTALL=OFF"
      "-DWITH_PYTHON_INSTALL_NUMPY=OFF"
      "-DWITH_PYTHON_INSTALL_REQUESTS=OFF"
      "-DWITH_SDL=OFF"
      "-DWITH_TBB=ON"
      "-DWITH_USD=ON"

      # Blender supplies its own FindAlembic.cmake (incompatible with the Alembic-supplied config file)
      "-DALEMBIC_INCLUDE_DIR=${lib.getDev alembic}/include"
      "-DALEMBIC_LIBRARY=${lib.getLib alembic}/lib/libAlembic${stdenv.hostPlatform.extensions.sharedLibrary}"
    ]
    ++ lib.optionals waylandSupport [
      "-DWITH_GHOST_WAYLAND=ON"
      "-DWITH_GHOST_WAYLAND_DBUS=ON"
      "-DWITH_GHOST_WAYLAND_DYNLOAD=OFF"
      "-DWITH_GHOST_WAYLAND_LIBDECOR=ON"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
      "-DWITH_CYCLES_EMBREE=OFF"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DLIBDIR=/does-not-exist"
      "-DWITH_CYCLES_OSL=OFF" # causes segfault on aarch64-darwin
      "-DSSE2NEON_INCLUDE_DIR=${sse2neon}/lib"
      "-DWITH_USD=OFF" # currently fails on darwin
    ]
    ++ lib.optional stdenv.cc.isClang "-DPYTHON_LINKFLAGS=" # Clang doesn't support "-export-dynamic"
    ++ lib.optional jackaudioSupport "-DWITH_JACK=ON"
    ++ lib.optionals cudaSupport [
      "-DOPTIX_ROOT_DIR=${optix}"
      "-DWITH_CYCLES_CUDA_BINARIES=ON"
      "-DWITH_CYCLES_DEVICE_OPTIX=ON"
    ];

  preConfigure = ''
    (
      expected_python_version=$(grep -E --only-matching 'set\(_PYTHON_VERSION_SUPPORTED [0-9.]+\)' build_files/cmake/Modules/FindPythonLibsUnix.cmake | grep -E --only-matching '[0-9.]+')
      actual_python_version=$(python -c 'import sys; print(".".join(map(str, sys.version_info[0:2])))')
      if ! [[ "$actual_python_version" = "$expected_python_version" ]]; then
        echo "wrong Python version, expected '$expected_python_version', got '$actual_python_version'" >&2
        exit 1
      fi
    )
  '';

  nativeBuildInputs =
    [
      cmake
      llvmPackages.llvm.dev
      makeWrapper
      python3Packages.wrapPython
    ]
    ++ lib.optionals cudaSupport [
      addDriverRunpath
      cudaPackages.cuda_nvcc
    ]
    ++ lib.optionals waylandSupport [ pkg-config ];

  buildInputs =
    [
      alembic
      boost
      ffmpeg
      fftw
      fftwFloat
      freetype
      gettext
      glew
      gmp
      jemalloc
      libepoxy
      libharu
      libjpeg
      libpng
      libsamplerate
      libsndfile
      libtiff
      libwebp
      opencolorio
      openexr
      openimageio
      openjpeg
      openpgl
      (opensubdiv.override { inherit cudaSupport; })
      openvdb
      potrace
      pugixml
      python3
      python3Packages.materialx
      tbb
      zlib
      zstd
    ]
    ++ lib.optionals (!stdenv.isAarch64 && stdenv.isLinux) [
      embree
      (openimagedenoise.override { inherit cudaSupport; })
    ]
    ++ (
      if (!stdenv.isDarwin) then
        [
          libGL
          libGLU
          libX11
          libXext
          libXi
          libXrender
          libXxf86vm
          openal
          openxr-loader
          pyPkgsOpenusd
        ]
      else
        [
          Cocoa
          CoreGraphics
          ForceFeedback
          OpenAL
          OpenGL
          SDL
          brotli
          embree
          llvmPackages.openmp
          (openimagedenoise.override { inherit cudaSupport; })
          sse2neon
        ]
    )
    ++ lib.optionals cudaSupport [ cudaPackages.cuda_cudart ]
    ++ lib.optionals waylandSupport [
      dbus
      libdecor'
      libffi
      libxkbcommon
      wayland
      wayland-protocols
    ]
    ++ lib.optional colladaSupport opencollada
    ++ lib.optional jackaudioSupport libjack2
    ++ lib.optional spaceNavSupport libspnav;

  pythonPath =
    let
      ps = python3Packages;
    in
    [
      ps.materialx
      ps.numpy
      ps.requests
      ps.zstandard
    ]
    ++ lib.optionals (!stdenv.isDarwin) [ pyPkgsOpenusd ];

  blenderExecutable =
    placeholder "out"
    + (if stdenv.isDarwin then "/Applications/Blender.app/Contents/MacOS/Blender" else "/bin/blender");

  postInstall =
    lib.optionalString stdenv.isDarwin ''
      mkdir $out/Applications
      mv $out/Blender.app $out/Applications
    ''
    + lib.optionalString stdenv.isLinux ''
      mv $out/share/blender/${lib.versions.majorMinor finalAttrs.version}/python{,-ext}
    ''
    + ''
      buildPythonPath "$pythonPath"
      wrapProgram $blenderExecutable \
        --prefix PATH : $program_PATH \
        --prefix PYTHONPATH : "$program_PYTHONPATH" \
        --add-flags '--python-use-system-env'
    '';

  # Set RUNPATH so that libcuda and libnvrtc in /run/opengl-driver(-32)/lib can be
  # found. See the explanation in libglvnd.
  postFixup =
    lib.optionalString cudaSupport ''
      for program in $out/bin/blender $out/bin/.blender-wrapped; do
        isELF "$program" || continue
        addDriverRunpath "$program"
      done
    ''
    + lib.optionalString stdenv.isDarwin ''
      makeWrapper $out/Applications/Blender.app/Contents/MacOS/Blender $out/bin/blender
    '';

  passthru = {
    python = python3;
    pythonPackages = python3Packages;

    withPackages =
      f:
      (callPackage ./wrapper.nix { }).override {
        blender = finalAttrs.finalPackage;
        extraModules = (f python3Packages);
      };

    tests = {
      render = runCommand "${finalAttrs.pname}-test" { nativeBuildInputs = [ mesa.llvmpipeHook ]; } ''
        set -euo pipefail
        cat <<'PYTHON' > scene-config.py
        import bpy
        bpy.context.scene.eevee.taa_render_samples = 32
        bpy.context.scene.cycles.samples = 32
        if ${if (stdenv.isAarch64 && stdenv.isLinux) then "True" else "False"}:
            bpy.context.scene.cycles.use_denoising = False
        bpy.context.scene.render.resolution_x = 100
        bpy.context.scene.render.resolution_y = 100
        bpy.context.scene.render.threads_mode = 'FIXED'
        bpy.context.scene.render.threads = 1
        PYTHON

        mkdir $out
        for engine in BLENDER_EEVEE_NEXT CYCLES; do
          echo "Rendering with $engine..."
          # Beware that argument order matters
          ${lib.getExe finalAttrs.finalPackage} \
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
      tester-cudaAvailable = cudaPackages.writeGpuTestPython { } ''
        import subprocess
        subprocess.run([${
          lib.concatMapStringsSep ", " (x: ''"${x}"'') [
            (lib.getExe (blender.override { cudaSupport = true; }))
            "--background"
            "-noaudio"
            "--python-exit-code"
            "1"
            "--python"
            "${./test-cuda.py}"
          ]
        }], check=True)  # noqa: E501
      '';
    };
  };

  meta = {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    # They comment two licenses: GPLv2 and Blender License, but they
    # say: "We've decided to cancel the BL offering for an indefinite period."
    # OptiX, enabled with cudaSupport, is non-free.
    license =
      with lib.licenses;
      [ gpl2Plus ] ++ lib.optional cudaSupport (unfree // { shortName = "NVidia OptiX EULA"; });

    platforms = [
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    # the current apple sdk is too old (currently 11_0) and fails to build "metal" on x86_64-darwin
    broken = stdenv.hostPlatform.system == "x86_64-darwin";
    maintainers = with lib.maintainers; [
      amarshall
      veprbl
    ];
    mainProgram = "blender";
  };
})
