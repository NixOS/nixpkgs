{ stdenv
, lib
, python3
, fetchPypi
, git
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.13.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hYIuSLK2HeeXPL28qKvkKwPVpOwObNGrVWbDq6B0/IA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "cryptography==" "cryptography>="
  '';

  propagatedBuildInputs = with python3.pkgs; [
    click
    pygments
    pyopenssl
    qrcode
    requests
    rollbar
    stripe
  ];

  nativeCheckInputs = [
    git
  ] ++ (with python3.pkgs; [
    httpretty
    pytestCheckHook
    sure
  ]);

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

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Gigalixir Command-Line Interface";
    homepage = "https://github.com/gigalixir/gigalixir-cli";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "gigalixir";
  };
}
