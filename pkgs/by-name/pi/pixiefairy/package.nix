{
  python3Packages,
  nix-gitignore,
  fetchFromGitHub,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "pixiefairy";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xhalo32";
    repo = "pixiefairy";
    tag = "v${version}";
    hash = "sha256-lV7/jIGVu3TS8HcpqNwAGRjx47bRi7NUSvBTbpe6FD8=";
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
