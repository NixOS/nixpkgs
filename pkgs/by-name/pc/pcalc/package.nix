{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:

stdenv.mkDerivation {
  pname = "pcalc";
  version = "20181202";

  src = fetchFromGitHub {
    owner = "vapier";
    repo = "pcalc";
    rev = "d93be9e19ecc0b2674cf00ec91cbb79d32ccb01d";
    sha256 = "sha256-m4xdsEJGKxLgp/d5ipxQ+cKG3z7rlvpPL6hELnDu6Hk=";
  };

  # Since C23, coercing functions with different parameter lists to a function pointer with no
  # parameter specified triggers a hard error: `symbol.c:92:22: error: initialization of
  # 'int (*)(void)' from incompatible pointer type 'int (*)(double)' [-Wincompatible-pointer-types]`
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  makeFlags = [ "DESTDIR= BINDIR=$(out)/bin" ];
  nativeBuildInputs = [
    bison
    flex
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://vapier.github.io/pcalc/";
    description = "Programmer's calculator";
    mainProgram = "pcalc";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ftrvxmtrx ];
    platforms = lib.platforms.unix;
  };
}
