{
  lib,
  ttyd,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "clive";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "clive";
    tag = "v${version}";
    hash = "sha256-mNx5SCBvhpxk9IkKp1j0oyPNZl91cAKHGIUzyYf+bYU=";
  };

  vendorHash = "sha256-jHvr2tWp8iscm6vgHdRTYlFmPOWlRG3lz8hl4PM6e/c=";
  subPackages = [ "." ];
  buildInputs = [ ttyd ];
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-X github.com/koki-develop/clive/cmd.version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clive --prefix PATH : ${ttyd}/bin
    installShellCompletion --cmd clive \
      --bash <($out/bin/clive completion bash) \
      --fish <($out/bin/clive completion fish) \
      --zsh <($out/bin/clive completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doinstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automates terminal operations";
    homepage = "https://github.com/koki-develop/clive";
    changelog = "https://github.com/koki-develop/clive/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misilelab ];
    mainProgram = "clive";
  };
}
