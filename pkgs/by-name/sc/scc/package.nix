{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "scc";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tFhYFHMscK3zfoQlaSxnA0pVuNQC1Xjn9jcZWkEV6XI=";
  };

  vendorHash = null;

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

  meta = {
    homepage = "https://github.com/boyter/scc";
    description = "Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with lib.maintainers; [
      sigma
    ];
    license = with lib.licenses; [
      mit
    ];
  };
})
