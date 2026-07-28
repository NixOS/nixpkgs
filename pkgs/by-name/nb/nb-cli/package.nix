{
  lib,
  fetchFromGitHub,
  python3,
  nb-cli,
  testers,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "nb-cli";
  version = "1.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nonebot";
    repo = "nb-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Vo+MmbaC+i/FZfrZywb2vgNQotafLyXpdBo6pDlZeaE=";
  };

  pythonRemoveDeps = [ "pip" ];

  # too strict
  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [
    babel
    pdm-backend
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
