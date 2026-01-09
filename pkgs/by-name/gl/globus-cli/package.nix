{
  lib,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "globus-cli";
  version = "3.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-cli";
    tag = version;
    hash = "sha256-TjJ0GBXRYSMbWfCkGJSBzToHEjoN5ZJAzZe2yiRJhtg=";
  };

  build-system = with python3Packages; [
    setuptools
    ruamel-yaml
  ];

  dependencies = with python3Packages; [
    globus-sdk
    click
    jmespath
    packaging
    typing-extensions
    requests
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = with python3Packages; [
    pytest
    pytest-xdist
    pytest-timeout
    responses

    click
    requests
    pyjwt
    cryptography
    packaging
    typing-extensions

    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  postInstall = ''
    mkdir -p completions/{bash,zsh}
    $out/bin/globus --bash-completer > completions/bash/globus
    $out/bin/globus --zsh-completer > completions/zsh/_globus
    installShellCompletion \
      --bash completions/bash/globus \
      --zsh completions/zsh/_globus
  '';

  meta = {
    mainProgram = "globus";
    description = "Command-line interface to Globus REST APIs, including the Transfer API and the Globus Auth API";
    homepage = "https://github.com/globus/globus-cli";
    changelog = "https://github.com/globus/globus-cli/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.richardjacton ];
  };
}
