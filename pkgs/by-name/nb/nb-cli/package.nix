{
  fetchPypi,
  lib,
  python3,
  versionCheckHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nb-cli";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "nb_cli";
    inherit version;
    hash = "sha256-kI3Uy79mv0b+h5wjrRN3My9jOFzryhkStieqaG0YFvM=";
  };

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

  nativeInstallCheckInputs = [ versionCheckHook ];

  # no test
  doCheck = false;

  pythonImportsCheck = [ "nb_cli" ];

  versionCheckProgram = "nb";

  meta = {
    description = "CLI for nonebot2";
    homepage = "https://cli.nonebot.dev";
    changelog = "https://github.com/nonebot/nb-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nb";
  };
}
