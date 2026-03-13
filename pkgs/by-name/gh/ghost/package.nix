{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ghost";
  version = "8.0.0-unstable-2025-11-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EntySec";
    repo = "Ghost";
    rev = "bf38c7e62e510caa1229e797ca3276e426235b03";
    hash = "sha256-c1mcx5mG45Rm/oJ+XFCo5uJqcqPQGgZnxRs7OcU8q+0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    adb-shell
    badges
    colorscript
    pex-entysec
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ghost" ];

  meta = {
    description = "Android post-exploitation framework";
    homepage = "https://github.com/EntySec/ghost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ghost";
  };
})
