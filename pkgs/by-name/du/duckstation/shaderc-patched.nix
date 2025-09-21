{
  fetchpatch,
  duckstation,
  shaderc,
}:

shaderc.overrideAttrs (old: {
  pname = "shaderc-patched-for-duckstation";
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
})
