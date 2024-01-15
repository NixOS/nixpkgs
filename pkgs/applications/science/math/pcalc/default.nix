{ lib, stdenv, fetchFromGitHub, bison, flex }:

stdenv.mkDerivation rec {
  pname = "pcalc";
  version = "20181202";

  src = fetchFromGitHub {
    owner = "vapier";
    repo = "pcalc";
    rev = "d93be9e19ecc0b2674cf00ec91cbb79d32ccb01d";
    sha256 = "sha256-m4xdsEJGKxLgp/d5ipxQ+cKG3z7rlvpPL6hELnDu6Hk=";
  };

  makeFlags = [ "DESTDIR= BINDIR=$(out)/bin" ];
  nativeBuildInputs = [ bison flex ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://vapier.github.io/pcalc/";
    description = "Programmer's calculator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ftrvxmtrx ];
    platforms = platforms.unix;
  };
}
