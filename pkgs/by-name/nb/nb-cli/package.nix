{
  fetchPypi,
  lib,
  nb-cli,
  python3,
  testers,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nb-cli";
  version = "1.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "nb_cli";
    inherit (finalAttrs) version;
    hash = "sha256-IbYyPZuhTkr4RInIR1lpMzl2+VYzu4IFQt2pOko92ZQ=";
  };

  pythonRelaxDeps = [
    "watchfiles"
    "noneprompt"
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
    nonestorage
    packaging
    pydantic
    pyfiglet
    textual
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
    changelog = "https://github.com/nonebot/nb-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nb";
  };
})
