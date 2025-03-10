{
  lib,
  git,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "charmcraft";
  version = "3.4.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    tag = version;
    hash = "sha256-TCr6iZHUIJ/dZhj8pWsCYKAfqv9LXD3fGP432UQh/Lo=";
  };

  postPatch = ''
    substituteInPlace charmcraft/__init__.py --replace-fail "dev" "${version}"
  '';

  dependencies = with python3Packages; [
    craft-application
    craft-cli
    craft-parts
    craft-platforms
    craft-providers
    craft-store
    distro
    docker
    humanize
    jinja2
    jsonschema
    pip
    pydantic
    python-dateutil
    pyyaml
    requests
    requests-toolbelt
    requests-unixsocket
    snap-helpers
    tabulate
    urllib3
  ];

  build-system = with python3Packages; [ setuptools-scm ];

  pythonRelaxDeps = [
    "urllib3"
    "craft-application"
    "pip"
    "pydantic"
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      freezegun
      hypothesis
      pyfakefs
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
      responses
      setuptools
    ]
    ++ [ git ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # Relies upon the `charm` tool being installed
    "test_validate_missing_charm"
    "test_read_charm_from_yaml_file_self_contained_success[full-bases.yaml]"
    "test_read_charm_from_yaml_file_self_contained_success[full-platforms.yaml]"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "charmcraft";
    description = "Build and publish Charmed Operators for deployment with Juju";
    homepage = "https://github.com/canonical/charmcraft";
    changelog = "https://github.com/canonical/charmcraft/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
