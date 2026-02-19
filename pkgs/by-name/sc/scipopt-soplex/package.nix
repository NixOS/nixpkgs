{
  lib,
  stdenv,
  cmake,
  gmp,
  mpfr,
  zlib,
  boost,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scipopt-soplex";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NN1UwwvLPfRIpL49UV8f2G4glUmTEywKNXK3m1LFHcg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    gmp
    mpfr
    zlib
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://soplex.zib.de/";
    description = "Sequential object-oriented simPlex";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "soplex";
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://soplex.zib.de/doc-${finalAttrs.version}/html/CHANGELOG.php";
    platforms = lib.platforms.unix;
  };
})
