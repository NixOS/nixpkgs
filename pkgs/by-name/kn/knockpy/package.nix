{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "knockpy";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knockpy";
    tag = finalAttrs.version;
    hash = "sha256-azgciGYf6Km6MuBE7RRHhcx1hhc309FTv3KOfZ25Iqo=";
  };

  pythonRelaxDeps = [
    "dnspython"
    "httpx"
    "pyopenssl"
    "python-dotenv"
    "rich"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    dnspython
    httpx
    h2
    pyopenssl
    python-dotenv
    rich
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "knockpy" ];

  meta = {
    description = "Tool to scan subdomains";
    homepage = "https://github.com/guelfoweb/knockpy";
    changelog = "https://github.com/guelfoweb/knockpy/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "knockpy";
  };
})
