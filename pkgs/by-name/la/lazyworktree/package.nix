{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lazyworktree";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "lazyworktree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qF9196fzKgU9iS7wlOBCYqxtxsauri7CWBEAPCVxo9g=";
  };

  vendorHash = "sha256-Ch/SsuHrCIFefIuQgK0fp5qSg9JX1zPwLEDsMDYIqxE=";

  nativeBuildInputs = [ installShellFiles ];

  # Tests require git and are integration tests
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm444 shell/functions.shell -t $out/share/lazyworktree
    installManPage lazyworktree.1
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
