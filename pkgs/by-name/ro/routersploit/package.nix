{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "routersploit";
  version = "3.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "routersploit";
    tag = "v${finalAttrs.version}";
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
  doCheck = python3.pythonOlder "3.14";

  nativeCheckInputs =
    with python3.pkgs;
    [
      pytest-xdist
      pytestCheckHook
    ]
    ++ lib.optionals (python3.pythonOlder "3.14") [
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

  disabledTestPaths =
    lib.optionals (python3.pythonOlder "3.14") [
      # AttributeError: module 'paramiko' has no attribute 'DSSKey'.
      "tests/test_exploit_scenarios.py::test_exploit_empty_response[Exploit119]"
      "tests/test_exploit_scenarios.py::test_exploit_error_response[Exploit119]"
      "tests/test_exploit_scenarios.py::test_exploit_not_found_response[Exploit119]"
      "tests/test_exploit_scenarios.py::test_exploit_redirect_response[Exploit119]"
      "tests/test_exploit_scenarios.py::test_exploit_timeout_response[Exploit119]"
      "tests/test_exploit_scenarios.py::test_exploit_trash_response[Exploit119]"
    ]
    ++ lib.optionals (python3.pythonOlder "3.14" && stdenv.hostPlatform.isDarwin) [
      # AttributeError: module 'paramiko' has no attribute 'DSSKey'.
      "tests/test_exploit_scenarios.py::test_exploit_empty_response[Exploit142]"
      "tests/test_exploit_scenarios.py::test_exploit_error_response[Exploit142]"
      "tests/test_exploit_scenarios.py::test_exploit_not_found_response[Exploit142]"
      "tests/test_exploit_scenarios.py::test_exploit_redirect_response[Exploit142]"
      "tests/test_exploit_scenarios.py::test_exploit_timeout_response[Exploit142]"
      "tests/test_exploit_scenarios.py::test_exploit_trash_response[Exploit142]"
    ];

  meta = {
    description = "Exploitation Framework for Embedded Devices";
    homepage = "https://github.com/threat9/routersploit";
    changelog = "https://github.com/threat9/routersploit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fab
      thtrf
    ];
    mainProgram = "rsf";
  };
})
