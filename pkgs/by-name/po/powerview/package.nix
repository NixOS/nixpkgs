{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "powerview";
  version = "2026.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aniqfakhrul";
    repo = "powerview.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sJAmdkcAfkwg6DsH0pLjIrvYDPbiPeQgMj81ZhPseDA=";
  };

  pythonRemoveDeps = [
    "argparse"
    "future"
    "flask-basicauth"
  ];

  pythonRelaxDeps = [ "chardet" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    chardet
    dnspython
    dsinternals
    fastmcp
    flask
    gnureadline
    gssapi
    impacket
    ldap3-bleeding-edge
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
    changelog = "https://github.com/aniqfakhrul/powerview.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "powerview";
  };
})
