{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Backport new predicated load/store instructions, needed by spirv-llvm-translator
    # Not in any tagged releases yet, should exist in the next release after 1.4.350.1.
    (fetchpatch {
      url = "https://github.com/KhronosGroup/SPIRV-Headers/commit/b8a32968473ce852a809b9de5f04f02a5a9dfa78.patch";
      hash = "sha256-59jmN28ifEhAxySXCpuGZ62jo1WVsRPnVosK8X4yrjM=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ralith ];
  };
})
