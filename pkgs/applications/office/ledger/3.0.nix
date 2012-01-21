{ stdenv, fetchgit, python, autoconf, automake, libtool, gettext, emacs, gmp
, pcre, expat, boost, mpfr, git, texinfo }:

let
  rev = "cf35984971341b8a8688";
in
stdenv.mkDerivation {
  name = "ledger3-2012.01.${rev}";

  src = fetchgit {
    url = "git://github.com/jwiegley/ledger.git";
    inherit rev;
    sha256 = "4078983db9fc8d232fa71a31b47e505c531971b4515d6ef723e7d333a2352d2a";
  };

  buildInputs = [
    python autoconf automake libtool gettext emacs gmp pcre expat boost mpfr
    git texinfo
  ];

  CPPFLAGS = "-I${gmp}/include -I${mpfr}/include";

  LDFLAGS = "-L${gmp}/lib -L${mpfr}/lib";

  buildPhase = ''
    sed -i acprep \
      -e 's|search_prefixes = .*|search_prefixes = ["${boost}"]|'
    export MAKEFLAGS="-j$NIX_BUILD_CORES -l$NIX_BUILD_CORES"
    python acprep update --no-pch --prefix=$out
  '';

  doCheck = !stdenv.isDarwin;

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
