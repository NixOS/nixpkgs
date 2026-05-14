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
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ralith ];
  };
})
