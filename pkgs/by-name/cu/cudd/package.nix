{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "cudd";
  version = "3.0.0";

  src = fetchurl {
    url = "https://davidkebo.com/source/cudd_versions/cudd-3.0.0.tar.gz";
    sha256 = "0sgbgv7ljfr0lwwwrb9wsnav7mw7jmr3k8mygwza15icass6dsdq";
  };

  configureFlags = [
    "--enable-dddmp"
    "--enable-obj"
  ];

  patches = [
    ./cudd.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://davidkebo.com/cudd";
    description = "Binary Decision Diagram (BDD) library";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chessai ];
  };
}
