{ lib, stdenv, fetchsvn, zlib, gmp, ecm }:

stdenv.mkDerivation rec {
  pname = "msieve";
  version = "r1050";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/msieve/code/trunk";
    rev = "1050";
    hash = "sha256-cn6OhE4zhrpB7BFrRdOnucjATbfo5mLkK7O0Usx1quE=";
  };

  buildInputs = [ zlib gmp ecm ];

  ECM = if ecm == null then "0" else "1";

  # Doesn't hurt Linux but lets clang-based platforms like Darwin work fine too
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "all" ];

  installPhase = ''
    mkdir -p $out/bin/
    cp msieve $out/bin/
  '';

  meta = {
    description = "C library implementing a suite of algorithms to factor large integers";
    mainProgram = "msieve";
    license = lib.licenses.publicDomain;
    homepage = "http://msieve.sourceforge.net/";
    maintainers = [ lib.maintainers.roconnor ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
  };
}
