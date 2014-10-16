{stdenv, fetchurl, gmp, libantlr3c, boost}:

stdenv.mkDerivation {
  name = "cvc4-1.4";
  src = fetchurl {
    url = http://cvc4.cs.nyu.edu/builds/src/cvc4-1.4.tar.gz;
    sha256 = "093h7zgv4z4ad503j30dpn8k2pz9m90pvd7gi5axdmwsxgwlzzkn";
  };

  buildInputs = [ gmp libantlr3c boost ];

  preConfigure = "patchShebangs ./src/";

  doChecks = true;

  meta = with stdenv.lib; {
    description = "An efficient open-source automatic theorem prover for satisfiability modulo theories (SMT) problems";
    homepage = http://cvc4.cs.nyu.edu/web/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl ];
  };
}
