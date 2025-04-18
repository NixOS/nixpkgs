{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "nginx-language-server";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pappasam";
    repo = "nginx-language-server";
    tag = "v${version}";
    hash = "sha256-v9+Y8NBvN8HvTdNrK9D9YQuqDB3olIu5LfYapjlVlAM=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = with python3Packages; [
    crossplane
    lsprotocol
    pydantic
    pygls
    typing-extensions
  ];

  pythonImportsCheck = [ "nginx_language_server" ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for nginx.conf";
    homepage = "https://github.com/pappasam/nginx-language-server";
    changelog = "https://github.com/pappasam/nginx-language-server/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nginx-language-server";
  };
}
