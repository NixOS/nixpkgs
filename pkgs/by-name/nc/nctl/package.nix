{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "nctl";
  version = "1.23.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ninech";
    repo = "nctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-THpS7EkNrU1kkWegAFWqMglaPDUJuPrstYQBWvu42kI=";
  };

  vendorHash = "sha256-UkgcsdvddBxer3rDaT3x0wjD7L5hF9ZkyhLI9quhjEs=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd nctl \
      --bash completions/nctl.bash \
      --zsh completions/nctl.zsh \
      --fish completions/nctl.fish
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI to interact with Nine API resources";
    homepage = "https://github.com/ninech/nctl";
    changelog = "https://github.com/ninech/nctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "nctl";
    maintainers = with lib.maintainers; [ thde ];
  };
})
