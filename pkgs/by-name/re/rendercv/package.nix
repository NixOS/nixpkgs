{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "rendercv";
<<<<<<< HEAD
  version = "2.6";
=======
  version = "2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rendercv";
    repo = "rendercv";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lGeZt/ctNmZu6kSTpH4JTmgOwR9gS6RVkWu0gr4FK4k=";
  };

  build-system = with python3Packages; [ uv-build ];
=======
    hash = "sha256-bIEuzMGV/l8Cunc4W04ESFYTKhNH+ffkA6eXGbyu3A0=";
  };

  build-system = with python3Packages; [ hatchling ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = with python3Packages; [
    jinja2
    phonenumbers
    email-validator
    pydantic
    pycountry
    pydantic-extra-types
    ruamel-yaml
<<<<<<< HEAD
    packaging
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # full
    typer
    markdown
    watchdog
    typst
    rendercv-fonts
<<<<<<< HEAD
=======
    packaging
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonRelaxDeps = [
    "phonenumbers"
    "pydantic-extra-types"
<<<<<<< HEAD
=======
    "pydantic"
    "ruamel-yaml"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "rendercv" ];

  nativeCheckInputs = with python3Packages; [
<<<<<<< HEAD
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # It fails due to missing internet resources
    "tests/renderer/test_pdf_png.py"
    "tests/cli/render_command/test_render_command.py"
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Typst-based CV/resume generator";
    homepage = "https://rendercv.com";
    changelog = "https://docs.rendercv.com/changelog/#26-december-23-2025";
=======
  patches = [
    ./remove_pycache_copy.patch
  ];

  meta = {
    description = "Typst-based CV/resume generator";
    homepage = "https://rendercv.com";
    changelog = "https://docs.rendercv.com/changelog/#22-january-25-2025";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "rendercv";
  };
}
