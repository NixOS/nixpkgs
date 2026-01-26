{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "meraki-cli";
  version = "1.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "meraki_cli";
    inherit version;
    hash = "sha256-FHcKgppclc0L6yuCkpVYfr+jq8hNkt7Hq/44mpHMR20=";
  };

  disabledTests = [
    # requires files not in PyPI tarball
    "TestDocVersions"
    "TestHelps"
    # requires running "pip install"
    "TestUpgrade"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    argcomplete
    jinja2
    meraki
    rich
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "meraki_cli"
  ];

  meta = {
    homepage = "https://github.com/PackeTsar/meraki-cli";
    description = "Simple CLI tool to automate and control your Cisco Meraki Dashboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylanmtaylor ];
    platforms = lib.platforms.unix;
    mainProgram = "meraki";
  };
}
