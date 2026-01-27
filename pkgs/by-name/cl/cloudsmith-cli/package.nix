{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "1.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudsmith-io";
    repo = "cloudsmith-cli";
    tag = "v${version}";
    hash = "sha256-uYtDzC21hSXiEHhIPn5EW5bfYvRR2OWv/R0qg1WZPrA=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    click
    click-configfile
    click-didyoumean
    click-spinner
    cloudsmith-api
    keyring
    requests
    requests-toolbelt
    semver
    urllib3
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
    freezegun
    httpretty
  ];

  pythonImportsCheck = [
    "cloudsmith_cli"
  ];

  preCheck = ''
    # When test_implicit_retry_for_status_codes calls initialise_api(),
    # and no user strings like LOGNAME or USER is set, getpass will call
    # getpwuid() which will then fail when we enable auto-allocate-uids.
    export USER=nixbld
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd "$out"
  '';

  disabledTests = [
    "TestMainCommand"
  ];

  meta = {
    homepage = "https://help.cloudsmith.io/docs/cli/";
    description = "Cloudsmith Command Line Interface";
    mainProgram = "cloudsmith";
    changelog = "https://github.com/cloudsmith-io/cloudsmith-cli/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ usertam ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
