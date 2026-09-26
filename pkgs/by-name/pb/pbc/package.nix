{
  lib,
  stdenv,
  fetchurl,
  gmp,
  flex,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pbc";
  version = "1.0.0";

  src = fetchurl {
    url = "https://crypto.stanford.edu/pbc/files/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-GCdaNnKDB3uv419EMgBJnjsZxKN1SVPaKhsvDWtZItw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    gmp
  ];
  nativeBuildInputs = [
    bison
    flex
  ];

  strictDeps = true;

  env = {
    LEX = "flex";
    LEXLIB = "-lfl";
    ac_cv_lib_fl_yywrap = "yes";
  };

  meta = {
    description = "Pairing-based cryptography library by Stanford";
    homepage = "https://crypto.stanford.edu/pbc/";
    license = with lib.licenses; [
      lgpl3Only
      asl20
    ];
    maintainers = with lib.maintainers; [ tphanir ];
    platforms = lib.platforms.unix;
  };
})
