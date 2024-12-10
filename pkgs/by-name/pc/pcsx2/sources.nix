{
  lib,
  fetchFromGitHub,
  fetchpatch,
  shaderc,
}:

let
  pcsx2 =
    let
      self = {
        pname = "pcsx2";
        version = "2.1.127";
        src = fetchFromGitHub {
          pname = "pcsx2-source";
          inherit (self) version;
          owner = "PCSX2";
          repo = "pcsx2";
          rev = "v${self.version}";
          hash = "sha256-zvvrGxGjIQjSmo18BDG2J3+PoysXj8WxpwtrcXK8LH8=";
        };
      };
    in
    self;

  # The pre-zipped files in releases don't have a versioned link, we need to zip
  # them ourselves
  pcsx2_patches =
    let
      self = {
        pname = "pcsx2_patches";
        version = "0-unstable-2024-09-05";
        src = fetchFromGitHub {
          pname = "pcsx2_patches-source";
          inherit (self) version;
          owner = "PCSX2";
          repo = "pcsx2_patches";
          rev = "377f30ae19acde655cc412086fa1840d16d54a93";
          hash = "sha256-g2SMMC/oHSF0G3+zwvk1vOoQgYFrPd3eaZ0jgGJIr5g=";
        };
      };
    in
    self;

  shaderc-patched =
    let
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
