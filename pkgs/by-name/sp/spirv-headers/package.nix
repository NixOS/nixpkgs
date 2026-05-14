{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-headers";
  version = "1.4.341.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-aYKFJxRDoY/Cor8gYVoR/YSyXWSNtcRG0HK8BZH0Ztk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ralith ];
  };
})
