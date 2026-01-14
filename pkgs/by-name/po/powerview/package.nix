{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "powerview";
  version = "2025.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aniqfakhrul";
    repo = "powerview.py";
    tag = version;
    hash = "sha256-kA7vb3YwUlolEnSJRFi+YZoq4yZsdMG+Snk7zsyOCmQ=";
  };

  pythonRemoveDeps = [
    "argparse"
    "future"
    "flask-basicauth"
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    chardet
    dnspython
    dsinternals
    flask
    gnureadline
    impacket
    ldap3-bleeding-edge
    mcp
    pycryptodome
    python-dateutil
    requests-ntlm
    tabulate
    validators
  ];

  optional-dependencies = with python3.pkgs; {
    mcp = [
      mcp
    ];
  };

  pythonImportsCheck = [ "powerview" ];

  meta = {
    description = "Alternative PowerView.ps1 script in Python";
    homepage = "https://github.com/aniqfakhrul/powerview.py";
    changelog = "https://github.com/aniqfakhrul/powerview.py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "powerview";
  };
}
