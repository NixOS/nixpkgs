{
  lib,
  fetchFromGitHub,
  installShellFiles,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpactor";
  version = "2024.11.28.1";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = finalAttrs.version;
    hash = "sha256-s/2Dcz7xrJJxun/KOQ+o+TFKHQT9D8uK1SXsLlKplT4=";
  };

  vendorHash = "sha256-vEw1RiZnMKtVo2pl0M7dTTs/TtNc9Vt8osAYptD46uA=";

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
