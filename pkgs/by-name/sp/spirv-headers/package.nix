{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-headers";
  version = "1.4.328.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-gewCQvcVRw+qdWPWRlYUMTt/aXrZ7Lea058WyqL5c08=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
})
