{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bdfresize";
  version = "1.5";

  src = fetchzip {
    url = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/bdfresize-${finalAttrs.version}.tar.gz";
    hash = "sha256-C4ZLJIn6vVeVUCpNwMu0vdfQQ3qUz4EVIcPob9NejP0=";
  };

  patches = [
    ./fix-configure.patch
    ./remove-malloc-declaration.patch
  ];

  # Fix compilation of getopt; see getopt package for more details
  env.NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__";

  meta = {
    description = "Tool to resize BDF fonts";
    homepage = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ malte-v ];
    mainProgram = "bdfresize";
  };
})
