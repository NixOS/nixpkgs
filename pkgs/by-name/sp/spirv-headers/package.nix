{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-headers";
  version = "1.4.363.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-PTD3GxQnENDngl6bf9YCmCVmvRgdBZczBosFCOCYEXU=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ralith ];
  };
})
