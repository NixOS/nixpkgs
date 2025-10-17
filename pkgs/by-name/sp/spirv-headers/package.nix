{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "spirv-headers";
  version = "1.4.321.0-unstable-2025-06-24";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    # The release for Vulkan SDK 1.4.321.0 is missing a PR required for
    # LLVM 21 support in SPIRV-LLVM-Translator; return to the
    # `vulkan-sdk-*` tags on the next stable release.
    rev = "9e3836d7d6023843a72ecd3fbf3f09b1b6747a9e";
    hash = "sha256-N8NBAkkpOcbgap4loPJJW6E5bjG+TixCh/HN259RyjI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
