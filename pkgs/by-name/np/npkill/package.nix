{ lib
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
}:

buildNpmPackage rec {
  pname = "npkill";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "voidcosmos";
    repo = "npkill";
    rev = "v${version}";
    hash = "sha256-0pouc+5kl5bjaNYz81OD5FZppYXKdyMBRvEq/DedEV4=";
  };

  npmDepsHash = "sha256-3ggcr0KxWbO5mHRgtB5rzGYQvpDoiy9EyRS0O+9MJEI=";

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
