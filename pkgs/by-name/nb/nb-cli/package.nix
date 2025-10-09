{
  fetchPypi,
  lib,
  nb-cli,
  python3,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nb-cli";
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "nb_cli";
    inherit version;
    hash = "sha256-HZey1RVpx/fHNxdEue1LczYbwYUxEb3i3fHpkKHhn+8=";
  };

  pythonRelaxDeps = [
    "watchfiles"
  ];

  build-system = [
    python3.pkgs.babel
    python3.pkgs.pdm-backend
  ];

  dependencies = with python3.pkgs; [
    anyio
    cashews
    click
    cookiecutter
    httpx
    importlib-metadata
    jinja2
    noneprompt
    pydantic
    pyfiglet
    tomlkit
    typing-extensions
    virtualenv
    watchfiles
    wcwidth
  ];

  # no test
  doCheck = false;

  pythonImportsCheck = [
    "nb_cli"
    "nb_cli.cli"
    "nb_cli.compat"
    "nb_cli.config"
    "nb_cli.handlers"
    "nb_cli.i18n"
    "nb_cli.log"
  ];

  passthru.tests = {
    version = testers.testVersion { package = nb-cli; };
  };

  meta = {
    description = "CLI for nonebot2";
    homepage = "https://cli.nonebot.dev";
    changelog = "https://github.com/nonebot/nb-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nb";
  };
}
