{
  lib,
  fetchFromGitHub,
  fetchpatch,
  shaderc,
}:

let
  pcsx2 = let
    self = {
      pname = "pcsx2";
      version = "2.1.102";
      src = fetchFromGitHub {
        pname = "pcsx2-source";
        inherit (self) version;
        owner = "PCSX2";
        repo = "pcsx2";
        rev = "v${self.version}";
        hash = "sha256-OBxrdZVx6HbSFO6sc2D2HP6iYH3ZKDj+uEqM7cxZNm0=";
      };
    };
  in
    self;

  # The pre-zipped files in releases don't have a versioned link, we need to zip
  # them ourselves
  pcsx2_patches = let
    self = {
      pname = "pcsx2_patches";
      version = "0-unstable-2024-08-12";
      src = fetchFromGitHub {
        pname = "pcsx2_patches-source";
        inherit (self) version;
        owner = "PCSX2";
        repo = "pcsx2_patches";
        rev = "9ea7fca481e1e4c2263ca69f9a5c9a70c92626dc";
        hash = "sha256-T0yTTW6P/NrZsANoduj+gCXyd5qqDRETxLblmnVnP/o=";
      };
    };
  in
    self;

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
in
{
  inherit pcsx2 pcsx2_patches shaderc-patched;
}
