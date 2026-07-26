{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication {
  pname = "leet-helix";
  version = "0-unstable-2026-03-01";

  src = fetchFromGitHub {
    owner = "Jarrlist";
    repo = "LeetHelix";
    rev = "abfb38e8cfb9086a58306f3032ba7f0c4b1588ea";
    hash = "sha256-ec9LWK/Vtb5+UoN9QKvYW3+RDOw6Dp4UxkeCW1BVnUQ=";
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
