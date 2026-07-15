{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spirv-headers";
  version = "1.4.350.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-nwzhJlkdN8DaExHvnuVc5rZmlrkPYb7Qmj1fx3O5Zpw=";
  };

  patches = [
    # backport to fix glslang tests
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://github.com/KhronosGroup/SPIRV-Headers/commit/1a22b167081842915a1c78a0b5b5a353a23284aa.diff";
      hash = "sha256-XUHfPHnk7bWK4vnozfW/84vaZN+rbFJUZSa6Og8GUAU=";
    })
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
