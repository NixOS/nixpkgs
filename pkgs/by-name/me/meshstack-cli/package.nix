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
  pname = "meshstack-cli";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meshcloud";
    repo = "meshstack-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KB1cpph68gf+KbhmOCQgkF0E7vxCBZMbYUCbpru5vms=";
  };

  vendorHash = "sha256-BWGrfEfxYXvXbwiKBWGuvOkuNn+dSxvPGKKAQtw89JM=";

  # docs/demo is a fake meshStack for the demo recording, not part of the CLI.
  excludedPackages = [ "docs/demo" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/meshcloud/meshstack-cli/cmd/internal.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd meshstack \
      --bash <($out/bin/meshstack completion bash) \
      --fish <($out/bin/meshstack completion fish) \
      --zsh <($out/bin/meshstack completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line interface for meshStack";
    homepage = "https://github.com/meshcloud/meshstack-cli";
    changelog = "https://github.com/meshcloud/meshstack-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      grubmeshi
      malhussan
    ];
    mainProgram = "meshstack";
  };
})
