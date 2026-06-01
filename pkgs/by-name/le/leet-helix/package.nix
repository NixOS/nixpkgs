{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "leet-helix";
  version = "0.2.3-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "Jarrlist";
    repo = "LeetHelix";
    rev = "d6e07920242ce852453d3d3b47d9418fda8baa8a";
    hash = "sha256-29RMI66tvSJxh1P2osRCJLvIXbwPy2lPPqtEsKQIWe4=";
  };

  pyproject = true;

  dependencies = with python3Packages; [
    typer
    rich
    sqlmodel
    sqlite-utils
  ];

  build-system = [ python3Packages.hatchling ];

  # necessary for tests which require a writable home
  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  doCheck = true;

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=HEAD" ]; };

  meta = {
    description = "Game to practice your Helix editor skills with code challenges";
    license = lib.licenses.mit;
    homepage = "https://github.com/Jarrlist/LeetHelix";
    maintainers = [ lib.maintainers.ricardomaps ];
    platforms = lib.platforms.all;
    mainProgram = "leet";
  };
}
