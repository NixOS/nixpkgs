{
  lib,
  fetchFromGitHub,
  fetchpatch,
  pcsx2,
  shaderc,
}:

{
  pcsx2 = let
    self = {
      pname = "pcsx2";
      version = "2.1.17";
      src = fetchFromGitHub {
        owner = "PCSX2";
        repo = "pcsx2";
        rev = "v${self.version}";
        hash = "sha256-yVao/8ZAssM0llKMR66fMbzsRL3WCkFyUk6ZD/MEaSc=";
      };
    };
  in
    self;

  # The pre-zipped files in releases don't have a versioned link, we need to zip
  # them ourselves
  pcsx2_patches = {
    pname = "pcsx2_patches";
    version = "0-unstable-2024-07-14";
    src = fetchFromGitHub {
      owner = "PCSX2";
      repo = "pcsx2_patches";
      rev = "afb17c4d851c54f93d4249e1e1dc8c57e2d0e6c6";
      hash = "sha256-OaZ5TMbxM4v4HhLa2ctM8xx//FQkHH3+dkxZX9/svjc=";
    };
  };

  shaderc-patched = let
    pname = "shaderc-patched-for-pcsx2";
    version = "2024.1";
    src = fetchFromGitHub {
      owner = "google";
      repo = "shaderc";
      rev = "v${version}";
      hash = "sha256-2L/8n6KLVZWXt6FrYraVlZV5YqbPHD7rzXPCkD0d4kg=";
    };
  in
    shaderc.overrideAttrs (old: {
      inherit pname version src;
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
    });
}
