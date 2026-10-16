{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rendercv";
  version = "2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rendercv";
    repo = "rendercv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iYfUoSN5HiDsAwkx44KbmHPN+vcYAra1zyfxTwziYkI=";
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
    markdown
    # full
    typer
    watchdog
    typst
    rendercv-fonts
    packaging
  ];

  pythonRelaxDeps = [
    "phonenumbers"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.3,<0.11.0" "uv_build"
  '';

  pythonImportsCheck = [ "rendercv" ];

  nativeCheckInputs = with python3Packages; [
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # It fails due to missing internet resources
    "tests/renderer/test_pdf_png.py"
    "tests/cli/render_command/test_render_command.py"
    "tests/test_pyodide.py"
    "tests/test_generated_files.py"
  ];

  doCheck = true;

  meta = {
    description = "Typst-based CV/resume generator";
    homepage = "https://rendercv.com";
    changelog = "https://docs.rendercv.com/changelog/#28-march-21-2026";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "rendercv";
  };
})
