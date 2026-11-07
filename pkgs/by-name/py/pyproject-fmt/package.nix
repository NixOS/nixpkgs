{
  lib,
  python3Packages,
  fetchPypi,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  runCommand,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyproject-fmt";
  version = "2.30.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "pyproject_fmt";
    inherit (finalAttrs) version;
    hash = "sha256-9yffmmh9Y7j6ApdXFhG6HCUUZ4fdODb6gFz1taYSCIc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gdT5Q8Vgm56lPIGhgT8oOW83zluTFslLhka6ZSk3sDg=";
  };

  # patch in import from vendored toml-fmt-common
  postPatch = ''
    substituteInPlace src/pyproject_fmt/__main__.py src/pyproject_fmt/_lib.pyi \
      --replace-fail "from toml_fmt_common import" "from pyproject_fmt._vendor.toml_fmt_common import"
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  # install vendored toml-fmt-common
  postInstall = ''
    vendor="$out/${python3Packages.python.sitePackages}/pyproject_fmt/_vendor"
    mkdir -p "$vendor"
    touch "$vendor/__init__.py"
    cp -r toml-fmt-common/src/toml_fmt_common "$vendor/"
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    trove-classifiers
  ];

  enabledTestPaths = [ "pyproject-fmt/tests" ];

  disabledTests = [
    "test_help_names_the_program[as-a-script]"
  ];

  pythonImportsCheck = [ "pyproject_fmt" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };

    tests.format =
      runCommand "pyproject-fmt-test-format" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          printf '[project]\nname="demo"\nversion="1.0.0"\n' > pyproject.toml
          pyproject-fmt pyproject.toml || [ $? -eq 1 ]
          grep -Fqx 'name = "demo"' pyproject.toml
          pyproject-fmt --check pyproject.toml
          touch $out
        '';
  };

  meta = {
    description = "Format your pyproject.toml file";
    homepage = "https://github.com/tox-dev/toml-fmt/tree/main/pyproject-fmt";
    changelog = "https://github.com/tox-dev/toml-fmt/releases/tag/pyproject-fmt%2F${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josh ];
    mainProgram = "pyproject-fmt";
  };
})
