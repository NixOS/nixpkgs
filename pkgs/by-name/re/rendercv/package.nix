{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rendercv";
  version = "2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rendercv";
    repo = "rendercv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lGeZt/ctNmZu6kSTpH4JTmgOwR9gS6RVkWu0gr4FK4k=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    jinja2
    phonenumbers
    email-validator
    pydantic
    pycountry
    pydantic-extra-types
    ruamel-yaml
    packaging
    # full
    typer
    markdown
    watchdog
    typst
    rendercv-fonts
  ];

  pythonRelaxDeps = [
    "phonenumbers"
    "pydantic-extra-types"
  ];

  pythonImportsCheck = [ "rendercv" ];

  nativeCheckInputs = with python3Packages; [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # It fails due to missing internet resources
    "tests/renderer/test_pdf_png.py"
    "tests/cli/render_command/test_render_command.py"
  ];

  doCheck = true;

  meta = {
    description = "Typst-based CV/resume generator";
    homepage = "https://rendercv.com";
    changelog = "https://docs.rendercv.com/changelog/#26-december-23-2025";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "rendercv";
  };
})
