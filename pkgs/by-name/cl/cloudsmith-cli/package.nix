{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "cloudsmith-cli";
  version = "1.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloudsmith-io";
    repo = "cloudsmith-cli";
    tag = "v${version}";
    hash = "sha256-PYqOj6nHjJrG7Ndc5vm//E8mjk4xZFVQopFqiWtH5ZQ=";
  };

  postPatch = ''
    # Fix compatibility with urllib3 >= 2.0 - method_whitelist renamed to allowed_methods
    # https://github.com/cloudsmith-io/cloudsmith-cli/pull/148
    substituteInPlace cloudsmith_cli/core/rest.py \
      --replace-fail 'method_whitelist=False' 'allowed_methods=False'
    substituteInPlace setup.py \
      --replace-fail 'urllib3<2.0' 'urllib3'
  '';

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
