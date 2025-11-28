{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2025-11-15";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "5bdcde01bf7c8f468581dc8bab54d3a5de04fb86";
    hash = "sha256-ndvqkYnD1skKhV3DHgKQkC5fsrbmt+COo+jGyLJjpDA=";
  };

  npmDepsHash = "sha256-LomwzsDT2I+fhcmiabj6CzwaSzV4bgV7azG6/TcJuQw=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
