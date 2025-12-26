{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "octotail";
  version = "1.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getbettr";
    repo = "octotail";
    tag = "v${version}";
    hash = "sha256-UC+3XLls8WL4yquCYc8QsPTrKrO5gO8v2NUTM3dMy18=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    fake-useragent
    mitmproxy
    pygithub
    pykka
    pyppeteer
    pyppeteer-stealth
    pyxdg
    returns
    rich
    shellingham
    termcolor
    typer
    websockets
  ];

  pythonImportsCheck = [
    "octotail"
  ];

  meta = {
    description = "Live tail GitHub Action runs on 'git push'. It's cursed";
    homepage = "https://github.com/getbettr/octotail";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "octotail";
  };
}
