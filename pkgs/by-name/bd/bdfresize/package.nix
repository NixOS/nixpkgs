{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "bdfresize";
  version = "1.5";

  src = fetchzip {
    url = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/bdfresize-${version}.tar.gz";
    hash = "sha256-C4ZLJIn6vVeVUCpNwMu0vdfQQ3qUz4EVIcPob9NejP0=";
  };

  patches = [
    ./fix-configure.patch
    ./remove-malloc-declaration.patch
  ];

  # Fix compilation of getopt; see getopt package for more details
  env.NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__";

  meta = with lib; {
    description = "Tool to resize BDF fonts";
    homepage = "http://openlab.ring.gr.jp/efont/dist/tools/bdfresize/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ malte-v ];
    mainProgram = "bdfresize";
  };
}
