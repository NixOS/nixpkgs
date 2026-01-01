{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "scc";
<<<<<<< HEAD
  version = "3.6.0";
=======
  version = "3.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tFhYFHMscK3zfoQlaSxnA0pVuNQC1Xjn9jcZWkEV6XI=";
=======
    hash = "sha256-ec3k6NL3zTYvcJo0bR/BqdTu5br4vRZpgrBR6Kj5YxY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/boyter/scc";
    description = "Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with lib.maintainers; [
      sigma
    ];
    license = with lib.licenses; [
=======
  meta = with lib; {
    homepage = "https://github.com/boyter/scc";
    description = "Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with maintainers; [
      sigma
      Br1ght0ne
    ];
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit
    ];
  };
}
