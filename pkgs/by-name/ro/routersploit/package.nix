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

  dependencies =
    with python3.pkgs;
    [
      paramiko
      pycryptodome
      pysnmp
      requests
      setuptools
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      standard-telnetlib
    ];

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

  disabledTests = [
    # AttributeError: module 'paramiko' has no attribute 'DSSKey'.
    "test_exploit_empty_response"
    "test_exploit_error_response"
    "test_exploit_not_found_response"
    "test_exploit_redirect_response"
    "test_exploit_trash_response"

    # Runs substantially slower, making this test flaky
    "test_exploit_timeout_response"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # port conflict when running simultaneous builds
    "test_http_scenario_service_empty_response"
    "test_http_scenario_service_error"
    "test_http_scenario_service_found"
    "test_http_scenario_service_not_found"
    "test_http_scenario_service_redirect"
    "test_http_scenario_service_trash"
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
