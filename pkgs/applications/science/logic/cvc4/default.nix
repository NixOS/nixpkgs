{ stdenv, fetchurl, gmp, libantlr3c, boost, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "cvc4-${version}";
  version = "1.4";

  src = fetchurl {
    url = "http://cvc4.cs.nyu.edu/builds/src/cvc4-${version}.tar.gz";
    sha256 = "093h7zgv4z4ad503j30dpn8k2pz9m90pvd7gi5axdmwsxgwlzzkn";
  };

  buildInputs = [ gmp libantlr3c boost autoreconfHook ];
  preConfigure = ''
    patchShebangs ./src/
    OLD_CPPFLAGS="$CPPFLAGS"
    export CPPFLAGS="$CPPFLAGS -P"
  '';
  postConfigure = ''CPPFLAGS="$OLD_CPPFLAGS"'';
  doChecks = true;

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = http://cvc4.cs.nyu.edu/web/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ vbgl thoughtpolice ];
  };
}
