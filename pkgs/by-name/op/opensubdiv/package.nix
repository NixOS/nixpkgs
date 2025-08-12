{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  xorg,
  libGLU,
  libGL,
  glew,
  ocl-icd,
  python3,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  openclSupport ? !cudaSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensubdiv";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenSubdiv";
    tag = "v${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-/22SeMzNNnrUgmPGpgbQwoYthdAdhRa615VhVJOvP9o=";
  };

  outputs = [
    "out"
    "dev"
    "static"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isUnix [
      libGLU
      libGL
      # FIXME: these are not actually needed, but the configure script wants them.
      glew
      xorg.libX11
      xorg.libXrandr
      xorg.libXxf86vm
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXi
    ]
    ++ lib.optionals (openclSupport && stdenv.hostPlatform.isLinux) [
      ocl-icd
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
    ];

  patches = [
    # Prevent CMake from generating a redundant nested path like /nix/store/.../nix/store/...
    ./cmake-config.patch
  ];

  # It's important to set OSD_CUDA_NVCC_FLAGS,
  # because otherwise OSD might piggyback unwanted architectures:
  # https://github.com/PixarAnimationStudios/OpenSubdiv/blob/7d0ab5530feef693ac0a920585b5c663b80773b3/CMakeLists.txt#L602
  preConfigure = lib.optionalString cudaSupport ''
    cmakeFlagsArray+=(
      -DOSD_CUDA_NVCC_FLAGS="${lib.concatStringsSep " " cudaPackages.flags.gencode}"
    )
  '';

  cmakeFlags = [
    (lib.mapAttrsToList lib.cmakeBool {
      NO_TUTORIALS = true;
      NO_REGRESSION = true;
      NO_EXAMPLES = true;
      NO_DX = stdenv.hostPlatform.isWindows;
      NO_METAL = !stdenv.hostPlatform.isDarwin;
      NO_OPENCL = !openclSupport;
      NO_CUDA = !cudaSupport;
    })
  ]
  ++ lib.optionals (stdenv.hostPlatform.isUnix && !stdenv.hostPlatform.isDarwin) [
    (lib.mapAttrsToList lib.cmakeFeature {
      GLEW_INCLUDE_DIR = "${glew.dev}/include";
      GLEW_LIBRARY = "${glew.dev}/lib";
    })
  ];

  preBuild =
    let
      maxBuildCores = 16;
    in
    lib.optionalString cudaSupport ''
      # https://github.com/PixarAnimationStudios/OpenSubdiv/issues/1313
      NIX_BUILD_CORES=$(( NIX_BUILD_CORES < ${toString maxBuildCores} ? NIX_BUILD_CORES : ${toString maxBuildCores} ))
    '';

  postInstall =
    if stdenv.hostPlatform.isWindows then
      ''
        ln -s $out $static
      ''
    else
      ''
        moveToOutput "lib/libosd*.a" $static
      '';

  postFixup = ''
    # Adjust static library path to reflect relocation to $static
    sed -i -E "s|\\\$\{_IMPORT_PREFIX\}/lib/(libosd.*\.a)|$static/lib/\1|" \
      $dev/lib/cmake/OpenSubdiv/OpenSubdivTargets-release.cmake
  '';

  meta = {
    description = "Open-Source subdivision surface library";
    homepage = "http://graphics.pixar.com/opensubdiv";
    broken = openclSupport && cudaSupport;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
})
