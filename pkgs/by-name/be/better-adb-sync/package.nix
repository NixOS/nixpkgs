{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "better-adb-sync";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jb2170";
    repo = "better-adb-sync";
    rev = "v${version}";
    hash = "sha256-ghOpcnQEZiAEZOiVWhrHa66WgiyyYQZgTJEokJFKMRs=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  pythonImportsCheck = [ "BetterADBSync" ];

  meta = {
    description = "Completely rewritten adbsync with --exclude";
    homepage = "https://github.com/jb2170/better-adb-sync";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lucc ];
    mainProgram = "better-adb-sync";
  };
}
