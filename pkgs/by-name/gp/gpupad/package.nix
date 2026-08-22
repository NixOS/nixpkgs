{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,

  directx-headers,
  directxmath,
  directxtex,
  getopt,
  glslang,
  imath,
  kissfft,
  nlohmann_json,
  openimageio,
  pipewire,
  qt6Packages,
  spdlog,
  spirv-cross,
  spirv-headers,
  spirv-reflect,
  spirv-tools,
  vulkan-headers,
  vulkan-loader,
  vulkan-memory-allocator,
}:

let
  ktx-src =
    (stdenv.mkDerivation {
      name = "ktx-src";
      # Revision pinned by GPUPAD_KTX_GIT_REVISION in CMakeLists.txt
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "KTX-Software";
        rev = "26cddc8d99386eb4120b8416956d54661fef15c5";
        hash = "sha256-j5v8e/WxgXYVKAvSoqJcevAhFH59YJJzfYSTc20pICc=";
      };

      nativeBuildInputs = [ getopt ];
      dontBuild = true;
      installPhase = ''
        runHook preInstall

        # Generate `version.h` files that ktx's cmake version.cmake
        # would otherwise try to regenerate inside the read-only
        # store output
        patchShebangs .
        for obj in tools/ktx lib/src; do
          ./scripts/mkversion -v v0.0.0-noversion -o version.h "$obj"
        done
        cp --recursive . "$out"

        runHook postInstall
      '';
    }).out;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpupad";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "gpupad";
    tag = finalAttrs.version;
    hash = "sha256-WZiXX5Nzrw7Od/cp7KzPY82Qz5fWr+IMU10Jd1v4Zac=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    glslang
    imath # needed for openimageio
    nlohmann_json
    openimageio
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtmultimedia
    spdlog
    spirv-headers
    spirv-tools
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    "-DVERSION=${finalAttrs.version}"
    "-DGPUPAD_NLOHMANN_JSON_FIND_PACKAGE=ON"
    "-DFETCHCONTENT_SOURCE_DIR_KTXSOFTWARE=${ktx-src}"
    "-DFETCHCONTENT_SOURCE_DIR_DIRECTX-HEADERS=${directx-headers.src}"
    "-DFETCHCONTENT_SOURCE_DIR_DIRECTXMATH=${directxmath.src}"
    "-DFETCHCONTENT_SOURCE_DIR_DIRECTXTEX=${directxtex.src}"
    "-DFETCHCONTENT_SOURCE_DIR_KISSFFT=${kissfft.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SPIRV-CROSS=${spirv-cross.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SPIRV-REFLECT=${spirv-reflect.src}"
    "-DFETCHCONTENT_SOURCE_DIR_VULKAN-MEMORY-ALLOCATOR=${vulkan-memory-allocator.src}"
  ];

  # qtmultimedia's ffmpeg backend dlopens libpipewire-0.3 at runtime,
  # so it is not kept in the shrunk RPATH
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pipewire ]}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flexible GLSL and HLSL shader editor and IDE";
    homepage = "https://github.com/houmain/gpupad";
    changelog = "https://github.com/houmain/gpupad/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "gpupad";
    platforms = lib.platforms.linux;
  };
})
