{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "rendercv";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rendercv";
    repo = "rendercv";
    tag = "v${version}";
    hash = "sha256-bIEuzMGV/l8Cunc4W04ESFYTKhNH+ffkA6eXGbyu3A0=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    jinja2
    phonenumbers
    email-validator
    pydantic
    pycountry
    pydantic-extra-types
    ruamel-yaml
    # full
    typer
    markdown
    watchdog
    typst
    rendercv-fonts
    packaging
  ];

  pythonRelaxDeps = [
    "phonenumbers"
    "pydantic-extra-types"
    "pydantic"
    "ruamel-yaml"
  ];

  pythonImportsCheck = [ "rendercv" ];

  nativeCheckInputs = with python3Packages; [
    pypdf
    pytestCheckHook
  ];

  disabledTests = [
    "test_are_all_the_theme_files_the_same"
    # It needs internet to download resources
    "test_render_a_pdf_from_typst"
    "test_render_pngs_from_typst"
    "test_render_command_overriding_input_file_settings"
  ];

  disabledTestPaths = [
    # It fails due to missing internet resources
    "tests/test_cli.py"
  ];

  doCheck = true;

  patches = [
    ./remove_pycache_copy.patch
  ];

  meta = {
    description = "Typst-based CV/resume generator";
    homepage = "https://rendercv.com";
    changelog = "https://docs.rendercv.com/changelog/#22-january-25-2025";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "rendercv";
  };
}
