{ stdenv, fetchgit, cmake, boost, gmp, mpfr, libedit, python
, texinfo, gnused }:

let
  rev = "5961384";
in

stdenv.mkDerivation {
  name = "ledger-3.0.4.${rev}";

  src = fetchgit {
    url = "git://github.com/ledger/ledger.git";
    inherit rev;
    sha256 = "0fmmhr3as4v2kb6h64k1fq979080cqhd75jvxfg7axk2mylb6b3q";
  };

  buildInputs = [ cmake boost gmp mpfr libedit python texinfo gnused ];

  enableParallelBuilding = true;

  # Skip byte-compiling of emacs-lisp files because this is currently
  # broken in ledger...
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v "$src/lisp/"*.el $out/share/emacs/site-lisp/
  '';

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
    maintainers = with stdenv.lib.maintainers; [ simons the-kenny jwiegley ];
  };
}
