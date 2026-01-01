{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
<<<<<<< HEAD
  version = "0-unstable-2025-12-01";
=======
  version = "0-unstable-2025-11-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
<<<<<<< HEAD
    rev = "5a3b292e791e7d33bacac8e9e952aef3aab9f867";
    hash = "sha256-EaJjeaR8cfqGy2I7nLxPlNyiq4ERpWqUF9i/LloOJaQ=";
  };

  npmDepsHash = "sha256-DCHrO+cuSepnBHl4miLivFElSmSbgH/NRQH68zSJAVA=";
=======
    rev = "5bdcde01bf7c8f468581dc8bab54d3a5de04fb86";
    hash = "sha256-ndvqkYnD1skKhV3DHgKQkC5fsrbmt+COo+jGyLJjpDA=";
  };

  npmDepsHash = "sha256-LomwzsDT2I+fhcmiabj6CzwaSzV4bgV7azG6/TcJuQw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
