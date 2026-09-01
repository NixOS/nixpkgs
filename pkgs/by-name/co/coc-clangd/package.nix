{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-08-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "e48dbb1bdba7f66e7b7497b7196051cf08510087";
    hash = "sha256-0nRxdFi21cQDXGAgKEvj4/s+XQgEfCJyScbs7POhBQU=";
  };

  npmDepsHash = "sha256-yDHhrBXe+87ZQsaMyfe3G3XOdz53u/JbiIjypDbSzLo=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
