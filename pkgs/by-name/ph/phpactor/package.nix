{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2025.02.21.0";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-c/tYyWTfMGfylhm0DCr8zCN8Qh0xGAb5aiMSou4khdg=";
  };

  vendorHash = "sha256-+Yar3FLE5Fhvj24vCBd9+2vEfNXlhaGPbP33Zpz5hzM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd phpactor \
    --bash <(php $out/bin/phpactor completion bash)
  '';

  meta = {
    changelog = "https://github.com/phpactor/phpactor/releases/tag/${finalAttrs.version}";
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
    maintainers = lib.teams.php.members;
  };
})
