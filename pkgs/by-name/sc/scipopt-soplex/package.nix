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
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5UTlSfnNPVCkAE2oMVukVbbs2drbSh0HfiDqXUktBHQ=";
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
    license = lib.licenses.asl20;
    mainProgram = "soplex";
    maintainers = with lib.maintainers; [ pmeinhold ];
    changelog = "https://soplex.zib.de/doc-${finalAttrs.version}/html/CHANGELOG.php";
    platforms = lib.platforms.unix;
  };
})
