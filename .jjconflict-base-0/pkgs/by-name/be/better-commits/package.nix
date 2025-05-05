{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-70PEcktGGck7egDmaIteFEMCNpo6ZuWyIVPiOywr2tc=";
  };

  npmDepsHash = "sha256-g34UutgT5315BpsQSuGGLIU6Ga+hpEz74HNLKKOB+ec=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI for creating better commits following the conventional commits specification";
    homepage = "https://github.com/Everduin94/better-commits";
    license = licenses.mit;
    maintainers = [ maintainers.ilarvne ];
    platforms = platforms.unix;
    mainProgram = "better-commits";
  };
}
