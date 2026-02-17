{
  bctoolbox,
  sqlite,
  lib,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "bzrtp";

  buildInputs = [
    bctoolbox
    sqlite
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
  ];

  meta = {
    description = "Opensource implementation of ZRTP keys exchange protocol. Part of the Linphone project";
    license = lib.licenses.gpl3Only;
  };
}
