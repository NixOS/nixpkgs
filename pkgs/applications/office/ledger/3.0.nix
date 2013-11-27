{ stdenv, fetchgit, cmake, boost, gmp, mpfr, libedit, python, texinfo }:

let
  rev = "0e5867bc5c";
in
stdenv.mkDerivation {
  name = "ledger3-2013.11.${rev}";

  src = fetchgit {
    url = "https://github.com/ledger/ledger.git";
    inherit rev;
    sha256 = "16aa63z24rp5vin7al8b6nzdi4kqpawbzvh148wfr2wj60vdb1n5";
  };

  buildInputs = [ cmake boost gmp mpfr libedit python texinfo ];

  # Tests on Darwin are failing
  doCheck = !stdenv.isDarwin;
  enableParallelBuilding = true;

  # Skip byte-compiling of emacs-lisp files because this is currently
  # broken in ledger...
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v $src/lisp/*.el $out/share/emacs/site-lisp/
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
    maintainers = with stdenv.lib.maintainers; [ simons the-kenny ];
  };
}
