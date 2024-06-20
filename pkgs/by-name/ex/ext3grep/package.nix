{ lib
, stdenv
, fetchurl
, fetchpatch
, e2fsprogs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ext3grep";
  version = "0.10.2";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ext3grep/ext3grep-${finalAttrs.version}.tar.gz";
    hash = "sha256-WG8+k50v/XgvbwBrgaPfLcR3xtoD8h7biGDFxPcZjz4=";
  };

  nativeBuildInputs = [ e2fsprogs ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ext3grep/-/raw/6150141b945dd12240629c07ada0a033b275baeb/debian/patches/001_fix-ftbfs-e2fsprogs_1.42-WIP-702.diff";
      hash = "sha256-27M+o3vw4eGCFpdqVLXX6b73a8v29yuKphMo8K0xJ3U=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ext3grep/-/raw/7c4bfb4c19eabaa11e6bf435289bfcd6e6847a9c/debian/patches/002_remove_i_dir_acl.diff";
      hash = "sha256-2bdlJ+zlsd7zX3ztV7NOTwSmEZf0N1BM8qJ/5avKX+M=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ext3grep/-/raw/58d63611bb8dfe5c4eacd568e79914f4f0cb2a0f/debian/patches/005_fix-FTBFS-dh-11.patch";
      hash = "sha256-GfiSMRxbGz1gDMfAjo+FRmNIRK1zq96TVkLBO03pzbI=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ext3grep/-/raw/8bb5322ced9b099d2af73e77d4a84b6e5b1a9f7f/debian/patches/010_fix-spellings.patch";
      hash = "sha256-YHUInewf634HaRFUW9djtRZqg7Wdqh/rjp0pbJuOT2M=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/ext3grep/-/raw/662e314abca7d466add8015fc3d2cd49653cffcf/debian/patches/015_fix-clang-build.patch";
      hash = "sha256-GctPFpBxdZYi5l2dtFTrFx4cTmDXV8BARvpwK+oxMdc=";
    })
  ];

  meta = with lib; {
    description = "Tool to investigate an ext3 file system for deleted content and possibly recover it";
    mainProgram = "ext3grep";
    homepage = "https://code.google.com/archive/p/ext3grep/";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
})
