{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "basedpyright";
  version = "1.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DetachHead";
    repo = "basedpyright";
    rev = "refs/tags/v${version}";
    hash = "sha256-n4jiKxkXGCKJkuXSsUktsiJQuCcZ+D/RJH/ippnOVw8=";
  };

  npmDepsHash = "sha256-4yc53xonguaPIem5/iWDw1g9D4DwuIBOTTny0UmhPB0=";

  # makeCacheWritable = true;
  npmFlags = [ "--legacy-peer-deps" ];

  meta = {
    description = "Pyright fork with various type checking improvements, improved vscode support and pylance features built into the language server";
    homepage = "https://github.com/DetachHead/basedpyright";
    changelog = "https://github.com/DetachHead/basedpyright/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "basedpyright";
  };
}
