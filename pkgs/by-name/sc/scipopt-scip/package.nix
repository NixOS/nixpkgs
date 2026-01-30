{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  readline,
  gmp,
  scipopt-soplex,
  scipopt-papilo,
  scipopt-zimpl,
  ipopt,
  onetbb,
  boost,
  gfortran,
  criterion,
  mpfr,
  enableZimpl ? (!stdenv.hostPlatform.isDarwin),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scipopt-scip";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "scip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KW7N2ORspzkaR/gdU//p38BV4GyuhoSIVb6q9RTrCYQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    scipopt-soplex
    scipopt-papilo
    ipopt
    gmp
    readline
    zlib
    onetbb
    boost
    gfortran
    criterion
  ]
  ++ lib.optional enableZimpl scipopt-zimpl;

  cmakeFlags = lib.optional (!enableZimpl) "-DZIMPL=OFF";

  propagatedBuildInputs = [ mpfr ];

  doCheck = true;

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://scipopt.org/doc-${finalAttrs.version}/html/RN${lib.versions.major finalAttrs.version}.php";
    description = "Solving Constraint Integer Programs";
    license = lib.licenses.asl20;
    homepage = "https://github.com/scipopt/scip";
    mainProgram = "scip";
  };
})
