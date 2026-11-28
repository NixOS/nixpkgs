{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "npkill";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "voidcosmos";
    repo = "npkill";
    rev = "v${version}";
    hash = "sha256-3Zy1hhbGueCl8ST2yR4aWOlQXf6rKtufFqlNSbPHVu0=";
  };

  npmDepsHash = "sha256-kIE6eSVqqBpnLzkUEZ8rSKcna39lyzh7jh4GoSKkc4M=";

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easily find and remove old and heavy node_modules folders";
    homepage = "https://npkill.js.org";
    changelog = "https://github.com/voidcosmos/npkill/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ averyanalex ];
    mainProgram = "npkill";
  };
}
