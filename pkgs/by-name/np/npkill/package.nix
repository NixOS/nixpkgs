{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "npkill";
  version = "0.12.2-1";

  src = fetchFromGitHub {
    owner = "voidcosmos";
    repo = "npkill";
    rev = "v${version}";
    hash = "sha256-I0qo8sRkG9GVAA4oLDiTDsHtdrmnkdAk7QOXMWWDKmA=";
  };

  npmDepsHash = "sha256-scR7LF9UkDvQzAqe5TSKajr6VNrnjM2KZI7k2KLmoCc=";

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
