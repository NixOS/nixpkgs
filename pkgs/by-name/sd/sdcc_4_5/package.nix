{
  lib,
  stdenv,
  sdcc,
  fetchurl,
  fetchpatch,
  autoconf,
  texinfo,
}:

sdcc.overrideAttrs (
  finalAttrs: prevAttrs: {
    __structuredAttrs = true;

    version = "4.5.0";

    src = fetchurl {
      url = "mirror://sourceforge/sdcc/sdcc-src-${finalAttrs.version}.tar.bz2";
      hash = "sha256-1QMEN/tDa7HZOo29v7RrqqYGEzGPT7P1hx1ygV0e7YA=";
    };

    outputs = [
      "out"
      "doc"
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      "man"
    ];

    nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [
      autoconf
      texinfo
    ];

    patches = [
      # Fix build with gcc15
      # https://sourceforge.net/p/sdcc/bugs/3846/
      (fetchpatch {
        name = "sdcc-fix-aslink-elf-signature.patch";
        url = "https://src.fedoraproject.org/rpms/sdcc/raw/4a7c2a7e32369461eb451fc6f4d678a010135afc/f/sdcc-4.4.0-aslink.patch";
        hash = "sha256-xGilNetecPBj2VV3ebmln5BKqs3OoWFf6y2S3TBTHMQ=";
      })
    ];

    postPatch = ''
      echo '.PHONY: install' >> sim/ucsim/Makefile.in
    '';
  }
)
