{
  fetchpatch,
  pcsx2,
  shaderc,
}:

shaderc.overrideAttrs (old: {
  pname = "shaderc-patched-for-pcsx2";
  patches = (old.patches or [ ]) ++ [
    (fetchpatch {
      url = "file://${pcsx2.src}/.github/workflows/scripts/common/shaderc-changes.patch";
      hash = "sha256-Ps/D+CdSbjVWg3ZGOEcgbpQbCNkI5Nuizm4E5qiM9Wo=";
      excludes = [
        "CHANGES"
        "CMakeLists.txt"
        "libshaderc/CMakeLists.txt"
      ];
    })
  ];
})
