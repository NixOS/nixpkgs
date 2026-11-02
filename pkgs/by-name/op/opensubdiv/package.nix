{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
  libGLU,
  libGL,
  glew,
  ocl-icd,
  python3,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  openclSupport ? !cudaSupport,
}:

let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  inherit (effectiveStdenv) hostPlatform;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "opensubdiv";
  version = "3.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "PixarAnimationStudios";
    repo = "OpenSubdiv";
    tag = "v${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-yWi+SaJfyMHPnc8hhrMZ4W6cBRkFOhRehXg3BqSGPcM=";
  };

  patches = [
    # Prevent CMake from generating a redundant nested path like /nix/store/.../nix/store/...
    ./cmake-config.patch
  ];

  # cudaThreadSynchronize was deprecated and removed in CUDA 13
  postPatch = lib.optionalString cudaSupport ''
    substituteInPlace opensubdiv/osd/cudaEvaluator.cpp \
      --replace-fail \
        "cudaThreadSynchronize" \
        "cudaDeviceSynchronize"
  '';

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
    lib.optionals hostPlatform.isUnix [
      libGLU
      libGL
      # FIXME: these are not actually needed, but the configure script wants them.
      glew
      libx11
      libxrandr
      libxxf86vm
      libxcursor
      libxinerama
      libxi
    ]
    ++ lib.optionals (openclSupport && hostPlatform.isLinux) [
      ocl-icd
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
    ];

  cmakeFlags =
    lib.mapAttrsToList lib.cmakeBool {
      NO_TUTORIALS = true;
      NO_REGRESSION = true;
      NO_EXAMPLES = true;
      NO_DX = hostPlatform.isWindows;
      NO_METAL = !hostPlatform.isDarwin;
      NO_OPENCL = !openclSupport;
      NO_CUDA = !cudaSupport;
    }
    ++ lib.optionals (hostPlatform.isUnix && !hostPlatform.isDarwin) (
      lib.mapAttrsToList lib.cmakeFeature {
        GLEW_INCLUDE_DIR = "${lib.getInclude glew}/include";
        GLEW_LIBRARY = "${lib.getLib glew}/lib";
      }
    )
    # It's important to set OSD_CUDA_NVCC_FLAGS,
    # because otherwise OSD might piggyback unwanted architectures:
    # https://github.com/PixarAnimationStudios/OpenSubdiv/blob/7d0ab5530feef693ac0a920585b5c663b80773b3/CMakeLists.txt#L602
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "OSD_CUDA_NVCC_FLAGS" (lib.concatStringsSep " " cudaPackages.flags.gencode))
    ];

  preBuild =
    let
      maxBuildCores = 12;
    in
    # https://github.com/PixarAnimationStudios/OpenSubdiv/issues/1313
    lib.optionalString cudaSupport ''
      NIX_BUILD_CORES=$(( NIX_BUILD_CORES < ${toString maxBuildCores} ? NIX_BUILD_CORES : ${toString maxBuildCores} ))
    '';

  postInstall =
    if hostPlatform.isWindows then
      ''
        ln -s $out $static
      ''
    else
      ''
        moveToOutput "lib/libosd*.a" $static
      '';

  # Adjust static library path to reflect relocation to $static
  postFixup = ''
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
