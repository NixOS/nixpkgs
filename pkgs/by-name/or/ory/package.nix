{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ory";
  version = "v1.1.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Su2FIuCb2vpPW/OCOTzqQOZPpY9gGRbwylSepLh2hk=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ory/cli/buildinfo.Version=${finalAttrs.version}"
  ];

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-VXaMc4VnHPljVugJyuGn8EQvNUBkEhbvepg2p7vw2EY=";

  postInstall = ''
    mv $out/bin/cli $out/bin/ory
    installShellCompletion --cmd ory \
      --bash <($out/bin/ory completion bash) \
      --fish <($out/bin/ory completion fish) \
      --zsh <($out/bin/ory completion zsh)
  '';

  doCheck = false;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "ory";
    description = "Ory CLI";
    homepage = "https://www.ory.sh/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      luleyleo
      nicolas-goudry
    ];
  };
})
