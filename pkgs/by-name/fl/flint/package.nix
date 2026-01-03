{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  windows,
  autoconf,
  automake,
  gettext,
  libtool,
  gmp,
  mpfr,
  ntl,
  blas,
  lapack,
  boehmgc,
  openblas ? null,
  withBlas ? true,
  withNtl ? !ntl.meta.broken,
  withGc ? false,
}:

assert
  withBlas
  -> openblas != null && blas.implementation == "openblas" && lapack.implementation == "openblas";

stdenv.mkDerivation (finalAttrs: {
  pname = "flint";
  version = "3.3.1";

  src = fetchurl {
    url = "https://flintlib.org/download/flint-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZNcOUTB2z6lx4EELWMHaXTURKRPppWtE4saBtFnT6vs=";
  };

  patches = [
    # Remove once/if https://github.com/flintlib/flint/pull/2411 is merged
    # Required or else during the check phase the build fails while
    # linking a test due to duplicate symbol errors
    ./checkPhase.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];

  propagatedBuildInputs = [
    mpfr
  ];

  buildInputs = [
    gmp
  ]
  ++ lib.optionals withBlas [
    openblas
  ]
  ++ lib.optionals withNtl [
    ntl
  ]
  ++ lib.optionals withGc [
    boehmgc
  ]
  ++ lib.optionals stdenv.hostPlatform.isMinGW [
    windows.pthreads
  ];

  # We're not using autoreconfHook because flint's bootstrap
  # script calls autoreconf, among other things.
  preConfigure = ''
    echo "Executing bootstrap.sh"
    ./bootstrap.sh
  '';

  configureFlags = [
    "--with-gmp=${gmp}"
    "--with-mpfr=${mpfr}"
  ]
  ++ lib.optionals withBlas [
    "--with-blas=${openblas}"
  ]
  ++ lib.optionals withNtl [
    "--with-ntl=${ntl}"
  ]
  ++ lib.optionals withGc [
    "--with-gc=${boehmgc}"
  ];

  enableParallelBuilding = true;
  enableParallelChecking = true;
  doCheck = true;

  meta = {
    description = "Fast Library for Number Theory";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.smasher164 ];
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.all;
    homepage = "https://www.flintlib.org/";
    downloadPage = "https://www.flintlib.org/downloads.html";
  };
})
