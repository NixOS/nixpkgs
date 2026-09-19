{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-reflect";
  version = "1.4.357.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Reflect";
    tag = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-RLT6NQg+4GPPX67FEVu3sOOsyFqB+Ol/ZoD5M8N+dEM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reflection API for SPIR-V shader bytecode in Vulkan applications";
    homepage = "https://github.com/KhronosGroup/SPIRV-Reflect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "spirv-reflect";
    platforms = lib.platforms.all;
  };
})
