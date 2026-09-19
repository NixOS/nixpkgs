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
  ktx-tools,
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
      src = ktx-tools.src.overrideAttrs (old: {
        fetchSubmodules = true;
        hash = "sha256-vxQ6QVsUeKFM8W5TS4TWZasWKXbXbxsbf72nKpVwBFE=";
      });

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
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "gpupad";
    tag = finalAttrs.version;
    hash = "sha256-xqkheFFnWkuFkcA3EAFUzvJAOlrqijWfNlGucMQ6gkI=";
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
