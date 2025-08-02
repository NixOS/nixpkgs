{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-dalCpupefZT1VDOo+U2MvqeWh1whi8w/697VOFJyuDw=";
  };

  npmDepsHash = "sha256-g34UutgT5315BpsQSuGGLIU6Ga+hpEz74HNLKKOB+ec=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for creating better commits following the conventional commits specification";
    homepage = "https://github.com/Everduin94/better-commits";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "better-commits";
  };
}
