{
  python3Packages,
  fetchFromGitHub,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "pixiefairy";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xhalo32";
    repo = "pixiefairy";
    tag = "v${version}";
    hash = "sha256-mqzdehvIUVJKatkMtD9Hmv6U4tRpyK84rDzM3yRvgZc=";
  };

  build-system = [ python3Packages.poetry-core ];
  dependencies = with python3Packages; [
    pyyaml
    click
    colorama
    fastapi
    gevent
    loguru
    pydantic-yaml
    shellingham
    typer
    urllib3
    uvicorn
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "Pixiecore API server companion";
    homepage = "https://github.com/xhalo32/pixiefairy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      niklashh
    ];
    mainProgram = "pixiefairy";
  };
}
