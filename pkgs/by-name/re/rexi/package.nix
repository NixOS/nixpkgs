{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rexi";
  version = "1.2.1-unstable-2026-06-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "royreznik";
    repo = "rexi";
    #tag = "v${finalAttrs.version}";
    # https://github.com/royreznik/rexi/pull/38
    rev = "d7f5793e57e522b02cbb69dc5da567587fcf3cab";
    hash = "sha256-RVY239SyQadbxtyyw4guzE2Q7a1Oxu5C4XBv0H3wd3E=";
  };

  # AttributeError: 'Static' object has no attribute 'renderable'.
  # In textual==0.6.0, the `renderable` property was renamed to `content`
  # https://github.com/Textualize/textual/pull/6041
  postPatch = ''
    substituteInPlace tests/test_ui.py \
      --replace-fail ".renderable" ".content"
  '';

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    colorama
    typer
    textual
    click
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonRelaxDeps = [
    "textual"
    "typer"
    "click"
  ];

  meta = {
    description = "User-friendly terminal UI to interactively work with regular expressions";
    homepage = "https://github.com/royreznik/rexi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gauravghodinde ];
    mainProgram = "rexi";
  };
})
