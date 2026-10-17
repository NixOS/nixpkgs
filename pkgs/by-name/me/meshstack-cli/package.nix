{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

# go.mod requires go 1.27, which is not yet the default go in nixpkgs.
buildGo127Module (finalAttrs: {
  pname = "meshstack-cli";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meshcloud";
    repo = "meshstack-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GCYPPqAoxqRYE4zG6M51NtvUFeHvBz8h6URPad8K0AU=";
  };

  vendorHash = "sha256-tQ9LvCSoYwwCnOH9XKOVbTfibAP5QSiuCNy0JnV18S0=";

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
    changelog = "https://github.com/meshcloud/meshstack-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      grubmeshi
      henryde
      JohannesRudolph
      malhussan
    ];
    mainProgram = "meshstack";
  };
})
