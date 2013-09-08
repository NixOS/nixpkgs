{ stdenv, fetchgit, cmake, boost, gmp, mpfr, libedit, python, texinfo }:

let
  rev = "0ec4291";
in
stdenv.mkDerivation {
  name = "ledger3-2013.08.${rev}";

  src = fetchgit {
    url = "https://github.com/ledger/ledger.git";
    inherit rev;
    sha256 = "1y4rcbx8y2fxkdc7i06n1i5jf3cq05bvzpb8498mis2gwfmkw470";
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
