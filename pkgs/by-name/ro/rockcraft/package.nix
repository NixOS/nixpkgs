{
  lib,
  python3Packages,
  fetchFromGitHub,
  dpkg,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "rockcraft";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "rockcraft";
    rev = version;
    hash = "sha256-yv+TGDSUBKJf5X+73Do9KrAcCodeBPqpIHgpYZslR3o=";
  };

  pyproject = true;

  build-system = with python3Packages; [ setuptools-scm ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "setuptools~=80.8.0" "setuptools"
  '';

  dependencies = with python3Packages; [
    craft-application
    craft-archives
    craft-platforms
    spdx-lookup
    tabulate
  ];

  pythonRelaxDeps = [
    "craft-providers"
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      craft-platforms
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
      versionCheckHook
      writableTmpDirAsHomeHook
    ]
    ++ [ dpkg ];

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    "test_project_all_platforms_invalid"
    "test_run_init_flask"
    "test_run_init_django"
    # Mock is broken for Unix FHS reasons.
    "test_run_pack_services"
  ];

  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "SSL_CERT_FILE" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "rockcraft";
    description = "Create OCI images using the language from Snapcraft and Charmcraft";
    homepage = "https://github.com/canonical/rockcraft";
    changelog = "https://github.com/canonical/rockcraft/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
