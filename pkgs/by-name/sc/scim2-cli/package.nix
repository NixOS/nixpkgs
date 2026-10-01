{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

let
  pp = python3Packages;
in
pp.buildPythonApplication (finalAttrs: {
  pname = "scim2-cli";
  version = "0.2.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-cli";
    tag = finalAttrs.version;
    hash = "sha256-24CqpyEZv5cGG9yp03ATc/m0IVvnIoPlYqODaxXMPRc=";
  };

  build-system = with pp; [
    hatchling
  ];

  nativeCheckInputs = with pp; [
    pytestCheckHook
    pytest-httpserver
  ];

  dependencies =
    with pp;
    [
      click
      pydanclick
      scim2-client
      scim2-tester
      sphinx-click-rst-to-ansi-formatter
    ]
    ++ scim2-tester.optional-dependencies.httpx;

  pythonRemoveDeps = [
    # docs only deps
    "pygments"
  ];

  pythonImportsCheck = [
    "scim2_cli"
  ];

  disabledTests = [
    # click >= 8.2: CliRunner no longer mixes stderr into stdout,
    # tests assert error messages in result.stdout
    "test_stdin_bad_json"
    "test_invalid_command"
    "test_no_command_scimclient_error"
    "test_no_command_validation_error"
    "test_command_validation_error"
    "test_command_scimclient_error"
    "test_scimclient_error"
    "test_bad_resource_type"
    "test_unknown_resource_type"
    "test_validation_error"
    "test_no_command_payload_without_an_id"
    "test_command_payload_without_an_id"
  ];

  pytestFlags = [
    # newer scim2-tester changed the CheckConfig constructor signature
    "--deselect=tests/test_test.py::test_nominal"
    "--deselect=tests/test_test.py::test_verbose"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SCIM application development CLI";
    homepage = "https://github.com/python-scim/scim2-cli";
    changelog = "https://github.com/python-scim/scim2-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ marcel ];
    mainProgram = "scim2-cli";
  };
})
