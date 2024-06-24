{
  lib,
  duckstation,
  fetchFromGitHub,
  fetchpatch,
  shaderc,
}:

shaderc.overrideAttrs (old: let
  version = "2024.0";
  src = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "v${version}";
    hash = "sha256-Cwp7WbaKWw/wL9m70wfYu47xoUGQW+QGeoYhbyyzstQ=";
  };
in
  {
    pname = "shaderc-patched-for-duckstation";
    inherit version src;
    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        url = "file://${duckstation.src}/scripts/shaderc-changes.patch";
        hash = "sha256-Ps/D+CdSbjVWg3ZGOEcgbpQbCNkI5Nuizm4E5qiM9Wo=";
        excludes = [
          "CHANGES"
          "CMakeLists.txt"
          "libshaderc/CMakeLists.txt"
        ];
      })
    ];
  }
)
