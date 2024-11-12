{
  lib,
  git,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "charmcraft";
  version = "3.2.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = "refs/tags/${version}";
    hash = "sha256-2MI2cbAohfTgbilxZcFvmxt/iVjR6zJ2o0gequB//hg=";
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
  ];

  nativeCheckInputs =
    with python3Packages;
    [
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
