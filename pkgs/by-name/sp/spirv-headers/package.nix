{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.4.321.0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    # The release for Vulkan SDK 1.4.321.0 is missing commits required
    # for LLVM 21 support in SPIRV-LLVM-Translator; return to the
    # `vulkan-sdk-*` tags on the next stable release.
    rev = "54ae32bce772b29a253b18583b86ab813ed1887c";
    hash = "sha256-p973iBWBzi31JS0tlbkEb62PQjPFD6nhb2EVyXGMZ+8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
