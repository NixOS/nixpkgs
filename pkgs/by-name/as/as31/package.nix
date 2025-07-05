{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "as31";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/as31/as31_${finalAttrs.version}.orig.tar.gz";
    name = "${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-zSEyWHFon5nyq717Mpmdv1XZ5Hz0e8ZABqsP8M83c1U=";
  };

  patches = [
    # Check return value of getline in run.c
    ./0000-getline-break.patch

    # fix build with gcc14
    (fetchpatch {
      url = "https://salsa.debian.org/debian/as31/-/raw/76735fbf1fb00ce70ffd98385137908b7bd9bd5c/debian/patches/update_sizebuf_types.patch";
      hash = "sha256-ERrPdY0afKwXmdSLoWmWR55nKfvmieGlz+nhwFWRnrM=";
    })
  ];

  postPatch = ''
    # parser.c is generated from parser.y; it is better to generate it via bison
    # instead of using the prebuilt one, especially in x86_64
    rm -f as31/parser.c
  '';

  preConfigure = ''
    chmod +x configure
  '';

  nativeBuildInputs = [
    bison
  ];

  meta = {
    homepage = "https://www.pjrc.com/tech/8051/tools/as31-doc.html";
    description = "8031/8051 assembler";
    mainProgram = "as31";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
