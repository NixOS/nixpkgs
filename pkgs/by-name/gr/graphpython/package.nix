{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "graphpython";
  version = "1.0-unstable-2024-07-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlcsec";
    repo = "Graphpython";
    # https://github.com/mlcsec/Graphpython/issues/1
    rev = "ee7dbda7fe881a9a207ca8661d42c505b8491ea3";
    hash = "sha256-64M/Cc49mlceY5roBVuSsDIcbDx+lrX6oSjPAu9YDwA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    cryptography
    dnspython
    pyjwt
    requests
    tabulate
    termcolor
    tqdm
  ];

  pythonImportsCheck = [ "Graphpython" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Microsoft Graph API (Entra, o365, and Intune) enumeration and exploitation toolkit";
    homepage = "https://github.com/mlcsec/Graphpython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "graphpython";
  };
}
