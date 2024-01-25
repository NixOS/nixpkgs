{ lib, python3Packages, fetchFromGitHub, frida-tools, litecli }:

python3Packages.buildPythonApplication rec {
  pname = "objection";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "objection";
    rev = "refs/tags/${version}";
    hash = "sha256-UXzQP34g0CzFHwJ6dVsKC8vUbUQnGwPA3Os6Oj1Rfp4=";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    frida-python
    prompt-toolkit
    click
    tabulate
    semver
    delegator-py
    requests
    flask
    pygments

    # need for update check
    # https://github.com/sensepost/objection/blob/master/objection/utils/update_checker.py#L7C20-L7C26
    setuptools

    frida-tools
    litecli
  ];

  pythonRelaxDeps = [
    "semver"
  ];

  # i can't figure out how to fix tests
  doCheck = false;

  pythonImportsCheck = [
    "frida"
    "prompt_toolkit"
    "click"
    "tabulate"
    "semver"
    "delegator"
    "requests"
    "flask"
    "pygments"
    "litecli"
    "pkg_resources"
  ];

  meta = with lib; {
    description = "Runtime mobile exploration";
    homepage = "https://github.com/sensepost/objection";
    changelog = "https://github.com/sensepost/objection/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ vizid ];
  };
}
