{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  version = "3.4.7";
in
python3.pkgs.buildPythonApplication {
  pname = "routersploit";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "routersploit";
    tag = "v${version}";
    hash = "sha256-10NBSY/mYjOWoz2XCJ1UvXUIYUW4csRJHHtDlWMO420=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    paramiko
    pycryptodome
    pysnmp
    requests
    setuptools
  ];

  # Tests are out-dated and support for newer pysnmp is not implemented yet
  doCheck = false;

  nativeCheckInputs = with python3.pkgs; [
    pytest-xdist
    pytestCheckHook
    threat9-test-bed
  ];

  postInstall = ''
    mv $out/bin/rsf.py $out/bin/rsf
  '';

  pythonImportsCheck = [ "routersploit" ];

  enabledTestPaths = [
    # Run the same tests as upstream does in the first round
    "tests/core/"
    "tests/test_exploit_scenarios.py"
    "tests/test_module_info.py"
  ];

  meta = {
    description = "Exploitation Framework for Embedded Devices";
    homepage = "https://github.com/threat9/routersploit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      thtrf
    ];
    mainProgram = "rsf";
  };
}
