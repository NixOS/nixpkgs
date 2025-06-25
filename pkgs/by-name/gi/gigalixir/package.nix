{
  stdenv,
  lib,
  python3Packages,
  fetchPypi,
  git,
}:

python3Packages.buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hYIuSLK2HeeXPL28qKvkKwPVpOwObNGrVWbDq6B0/IA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," "" \
      --replace-fail "cryptography==" "cryptography>="
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
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
    broken = stdenv.hostPlatform.isDarwin;
    description = "Gigalixir Command-Line Interface";
    homepage = "https://github.com/gigalixir/gigalixir-cli";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gigalixir";
  };
}
