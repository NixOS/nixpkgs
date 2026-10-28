{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "1b948b02b473de36879c81c7807c1c475213b1f4";
    hash = "sha256-XBWtZe54YReMj4kKeqy46xminRKMyICxipC+MxXQl8E=";
  };

  npmDepsHash = "sha256-BBQNMBBZKpD2mj1V2BsxjG3syg20z83WEu9qberM1Nw=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
