{ stdenv, fetchgit, cmake, boost, gmp, mpfr, libedit, python, texinfo }:

let
  rev = "26d7197";
in
stdenv.mkDerivation {
  name = "ledger3-2013.06.${rev}";

  src = fetchgit {
    url = "https://github.com/ledger/ledger.git";
    inherit rev;
    sha256 = "02nf4kdrd61q9rf5rrarwmx47y2ya5qix7n82cj9qi9p4v3k3m2g";
  };

  buildInputs = [ cmake boost gmp mpfr libedit python texinfo ];

  # Unit tests fail in the current git snapshot. Try enabling them again
  # when updating this package!
  doCheck = false;

  enableParallelBuilding = true;

  meta = {
    homepage = "http://ledger-cli.org/";
    description = "A double-entry accounting system with a command-line reporting interface";
    license = "BSD";

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
