{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage {
  pname = "htmx-lsp";
  version = "0.2.0-unstable-2025-10-18";

  src = fetchFromGitHub {
    owner = "ThePrimeagen";
    repo = "htmx-lsp";
    rev = "a05bf01d33710f1e86e3e4165badda9826a7a9bb";
    hash = "sha256-IX24OeYc/R9DJzWICmk5NL6HXzeAXZWjlyNa1Ehtc/w=";
  };

  cargoHash = "sha256-Z3t9MJ56k5MYNLLyrKpT8WeWc1+N4IhdhIgxsqjefCc=";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Language server implementation for htmx";
    homepage = "https://github.com/ThePrimeagen/htmx-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "htmx-lsp";
  };
}
