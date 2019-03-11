{ stdenv, fetchFromGitHub, cmake, boost, gmp, mpfr, libedit, python
, texinfo, gnused, usePython ? true }:

stdenv.mkDerivation rec {
  name = "ledger-${version}";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner  = "ledger";
    repo   = "ledger";
    rev    = version;
    sha256 = "0hwnipj2m9p95hhyv6kyq54m27g14r58gnsy2my883kxhpcyb2vc";
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
