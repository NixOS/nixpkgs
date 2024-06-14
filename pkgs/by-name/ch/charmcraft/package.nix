{
  lib,
  git,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "charmcraft";
  version = "2.6.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    rev = "refs/tags/${version}";
    hash = "sha256-B0ZcOORW6yaSIpisPLnq5/S/CcqqvHNTXcfP1sKW2KQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'version=determine_version()' 'version="${version}"'
  '';

  propagatedBuildInputs = with python3Packages; [
    craft-cli
    craft-parts
    craft-providers
    craft-store
    distro
    humanize
    jinja2
    jsonschema
    pydantic_1
    python-dateutil
    pyyaml
    requests
    requests-toolbelt
    requests-unixsocket
    snap-helpers
    tabulate
    urllib3
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "urllib3"
  ];

  nativeCheckInputs = with python3Packages; [
    pyfakefs
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    responses
  ] ++ [ git ];

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
