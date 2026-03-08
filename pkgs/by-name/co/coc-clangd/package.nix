{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-02-28";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "31ae53163962607a5c2c49040ee6cefa5a7ff368";
    hash = "sha256-1BOC1Fsald7yQoaexLwX9jdUA+Mnj9aVio9lsVX7VVQ=";
  };

  npmDepsHash = "sha256-a8qkcUhPnNw1pbfdR7Cs1kLdBvtMPIu8Lgu/JJcqR9I=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
