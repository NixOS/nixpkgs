{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  nix-update-script,
  testers,
}:
buildGoModule (finalAttrs: {
  pname = "az-pim-cli";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "netr0m";
    repo = "az-pim-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zi/DNTroMews4PvPCeLWSq74xWdZ22NO2VtmW91zcfs=";
  };

  patches = [
    # removes info we don't have from version command
    ./version-build-info.patch
  ];

  vendorHash = "sha256-g4NcRNmHXS3mOtE0nbV96vFFoVzGFbAvcj/vkdXshoU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-X github.com/netr0m/az-pim-cli/cmd.version=v${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd az-pim-cli \
      --bash <($out/bin/az-pim-cli completion bash) \
      --fish <($out/bin/az-pim-cli completion fish) \
      --zsh <($out/bin/az-pim-cli completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "HOME=$TMPDIR az-pim-cli version";
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "List and activate Azure Entra ID Privileged Identity Management roles from the CLI";
    homepage = "https://github.com/netr0m/az-pim-cli";
    changelog = "https://github.com/netr0m/az-pim-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.awwpotato ];
    mainProgram = "az-pim-cli";
  };
})
