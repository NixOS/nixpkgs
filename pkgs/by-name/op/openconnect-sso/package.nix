{
  lib,
  openconnect,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:
python3Packages.buildPythonApplication rec {
  pname = "openconnect-sso";
  version = "0.8.1-unstable-2023-08-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "openconnect-sso";
    rev = "94128073ef49acb3bad84a2ae19fdef926ab7bdf";
    hash = "sha256-JFVvTw11KFnrd/A5z3QCh30ac9MZG+ojDY3udAFpmCE=";
  };

  patches = [
    ./0001-feat-upgrade-poetry-to-v2-min-python-version-3.10-up.patch
    ./0002-Fix-deprecated-code.patch
  ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    pyqt6
    pyqt6-webengine
    pysocks
    attrs
    colorama
    keyring
    lxml
    prompt-toolkit
    pyotp
    pyxdg
    requests
    structlog
    toml
  ];

  pythonRelaxDeps = [
    "keyring"
  ];

  propagatedBuildInputs = [ openconnect ];

  meta = {
    changelog = "https://github.com/vlaci/openconnect-sso/blob/${src.rev}/CHANGELOG.md";
    description = "Wrapper script for OpenConnect supporting Azure AD (SAMLv2) authentication to Cisco SSL-VPNs";
    homepage = "https://github.com/vlaci/openconnect-sso";
    license = lib.licenses.gpl3Only;
    mainProgram = "openconnect-sso";
    maintainers = with lib.maintainers; [
      kuflierl
    ];
  };
}
