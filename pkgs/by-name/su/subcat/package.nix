{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "subcat";
  version = "1.4.0-unstable-2025-05-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duty1g";
    repo = "subcat";
    rev = "1b3d015b064f244bfbc05114e4d30ab17861fb46";
    hash = "sha256-Jft+3ZM9+luvRwO/pL3iTYkz+322TQ/HTD38MttJjQU=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pyyaml
    requests
    urllib3
  ];

  pythonImportsCheck = [ "subcat" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Subdomain discovery tool";
    homepage = "https://github.com/duty1g/subcat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "subcat";
  };
}
