{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "better-commits";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "Everduin94";
    repo = "better-commits";
    tag = "v${version}";
    hash = "sha256-d2e+vA8qPr5H70X6caeW+s4yjI1zGByvmZd50j2nAQI=";
  };

  npmDepsHash = "sha256-18fkqQ3Y0fflSGXDPaMpHW7nC0ARMoCStxBzkEXiujs=";

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
