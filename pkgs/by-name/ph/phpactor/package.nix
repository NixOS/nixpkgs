{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
  phpRuntime ? php.withExtensions (
    { all, ... }:
    with all;
    [
      mbstring
      tokenizer
    ]
  ),
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2025.04.17.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-HJH+31qAE4shamRl1/+TRtje0ZzOtPV7l++NIaacmxE=";
  };

  vendorHash = "sha256-qdR8/ME9H7gusALjXXbKl8hj20N704Nw1tC3V9xTcEY=";

  nativeBuildInputs = [ installShellFiles ];

  php = phpRuntime;

  postInstall = ''
    installShellCompletion --cmd phpactor \
    --bash <(php $out/bin/phpactor completion bash)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    teams = [ lib.teams.php ];
  };
})
