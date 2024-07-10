{
  lib,
  fetchFromGitHub,
  fetchpatch,
  pcsx2,
  shaderc,
}:

let
  version = "2024.1";
in
shaderc.overrideAttrs (old: {
  inherit version;
  pname = "shaderc-patched-for-pcsx2";
  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    hash = "sha256-2L/8n6KLVZWXt6FrYraVlZV5YqbPHD7rzXPCkD0d4kg=";
  };
  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      url = "file://${pcsx2.src}/.github/workflows/scripts/common/shaderc-changes.patch";
      hash = "sha256-/qX2yD0RBuPh4Cf7n6OjVA2IyurpaCgvCEsIX/hXFdQ=";
      excludes = [
        "libshaderc/CMakeLists.txt"
        "third_party/CMakeLists.txt"
      ];
    })
  ];
  cmakeFlags = (old.cmakeFlags or [ ]) ++ [
    (lib.cmakeBool "SHADERC_SKIP_EXAMPLES" true)
    (lib.cmakeBool "SHADERC_SKIP_TESTS" true)
  ];
})
