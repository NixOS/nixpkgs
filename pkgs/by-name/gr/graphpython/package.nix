{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "graphpython";
  version = "1.0-unstable-2026-09-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlcsec";
    repo = "Graphpython";
    # https://github.com/mlcsec/Graphpython/issues/1
    rev = "cfa9ec0c081a631948c66eb31f468624425ddcf9";
    hash = "sha256-MJsQhu5CbV5Ta+kAq7s8Aym3xyCeBNbbKIXh6MRocf0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    cryptography
    dnspython
    prompt-toolkit
    pyjwt
    requests
    tabulate
    termcolor
    tqdm
  ];

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
