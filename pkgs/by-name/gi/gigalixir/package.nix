{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
}:

python3Packages.buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gigalixir";
    repo = "gigalixir-cli";
    tag = "v${version}";
    hash = "sha256-OCPxOVWHUvH3Tj9bR+aj2VUNNuY5GWhnDaSKRDqLSvI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    importlib-metadata
    click
    pygments
    pyopenssl
    qrcode
    requests
    rollbar
    stripe
  ];

  nativeCheckInputs = with python3Packages; [
    git

    httpretty
    pytestCheckHook
    sure
  ];

  disabledTests = [
    # Test requires network access
    "test_rollback_without_version"
    "test_rollback"
    "test_create_user"
    # These following test's are now depraced and removed, check out these commits:
    # https://github.com/gigalixir/gigalixir-cli/commit/00b758ed462ad8eff6ff0b16cd37fa71f75b2d7d
    # https://github.com/gigalixir/gigalixir-cli/commit/76fa25f96e71fd75cc22e5439b4a8f9e9ec4e3e5
    "test_create_config"
    "test_delete_free_database"
    "test_get_free_databases"
  ];

  pythonImportsCheck = [
    "gigalixir"
  ];

  meta = {
    description = "Gigalixir Command-Line Interface";
    homepage = "https://github.com/gigalixir/gigalixir-cli";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gigalixir";
  };
}
