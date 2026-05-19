{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "66f32d29cf40417978514550db1c9a144c5d9f4f";
    hash = "sha256-rJ6e7xX8H3aN17PzG77W4iNh7xbQdn6Xz+D+4y57FLE=";
  };

  npmDepsHash = "sha256-Ypda0+PSYHPg8FK5sJYQkQbHEK1WTn9BoCjaJEGv6cQ=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
