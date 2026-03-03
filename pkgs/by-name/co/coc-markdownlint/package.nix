{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "fd55872a9b85501d179b3f4dd90508c29a2bd330";
    hash = "sha256-oJxMlILI69W7jeuK0EXRn/HJhwXb2OfIhyeNzZoq/FM=";
  };

  npmDepsHash = "sha256-Lfg8N2YIGaWtNBkXeGBdt4q5aQRMucKp6xlQgOAsxeg=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
