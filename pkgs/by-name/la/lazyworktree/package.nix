{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lazyworktree";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "lazyworktree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lxh6N1SY1FoEyfDeFTqDdiDMNASwn2QyiyUwve56Dn0=";
  };

  vendorHash = "sha256-I0MIfk2/ZtjHBzovxijFw5N4siEUdjXEIs5WbNdAzu8=";

  nativeBuildInputs = [ installShellFiles ];

  # Tests require git and are integration tests
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm444 shell/functions.{bash,fish,zsh} -t $out/share/lazyworktree
    installManPage lazyworktree.1
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lazyworktree \
      --bash <($out/bin/lazyworktree completion bash --code) \
      --zsh <($out/bin/lazyworktree completion zsh --code) \
      --fish <($out/bin/lazyworktree completion fish --code)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BubbleTea-based Terminal User Interface for efficient Git worktree management";
    homepage = "https://github.com/chmouel/lazyworktree";
    changelog = "https://github.com/chmouel/lazyworktree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      chmouel
      vdemeester
    ];
    mainProgram = "lazyworktree";
  };
})
