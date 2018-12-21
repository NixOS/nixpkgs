{ stdenv, fetchFromGitHub, cmake, boost, gmp, mpfr, libedit, python
, texinfo, gnused, usePython ? true }:

stdenv.mkDerivation rec {
  name = "ledger-${version}";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner  = "ledger";
    repo   = "ledger";
    rev    = "v${version}";
    sha256 = "1j4p7djkmdmd858hylrsc3inamh9z0vkfl98s9wiqfmrzw51pmxp";
    fetchSubmodules = true;
  };

  buildInputs = [
    (boost.override { enablePython = usePython; })
    gmp mpfr libedit python texinfo gnused
  ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_DOCS:BOOL=ON"
    (stdenv.lib.optionalString usePython "-DUSE_PYTHON=true")
   ];

  postBuild = ''
    make doc
  '';

  # Skip byte-compiling of emacs-lisp files because this is currently
  # broken in ledger...
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v "$src/lisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = with stdenv.lib; {
    homepage = https://ledger-cli.org/;
    description = "A double-entry accounting system with a command-line reporting interface";
    license = licenses.bsd3;

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = platforms.all;
    maintainers = with maintainers; [ the-kenny jwiegley ];
  };
}
