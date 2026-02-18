{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "d4f246f326f066637653eafdf60e12e6b159827d";
    hash = "sha256-+ydeReWxXp93PtU0zv8OEuSpIebqi1avGNzopyKXeD0=";
  };

  npmDepsHash = "sha256-1331Qaz9BXOeg6NsHuIokXI6VAjiRoslbLT3hXcjgak=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
