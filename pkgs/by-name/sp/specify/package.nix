{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {

  pname = "specify";
  version = "0.0.62";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    tag = "v${version}";
    hash = "sha256-WT1M6M/i9UHsFkbNEFp572tqGxEiFvl+EDDoCF6achU=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    typer
    rich
    httpx
    platformdirs
    readchar
    truststore
  ];

  meta = {
    description = "CLI tool to bootstraps projects for SDD and works with AI coding agents";
    homepage = "https://github.com/github/spec-kit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chuckorde ];
  };
}
