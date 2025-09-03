{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knockpy";
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "guelfoweb";
    repo = "knock";
    tag = version;
    hash = "sha256-tJNosM8zGzH0uMvVawoBl2d+8xkVzTIjycnHHjnMzSo=";
  };

  pythonRelaxDeps = [
    "beautifulsoup4"
    "dnspython"
    "pyopenssl"
    "requests"
    "tqdm"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    dnspython
    pyopenssl
    requests
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "knock" ];

  meta = {
    description = "Tool to scan subdomains";
    homepage = "https://github.com/guelfoweb/knock";
    changelog = "https://github.com/guelfoweb/knock/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "knockpy";
  };
}
