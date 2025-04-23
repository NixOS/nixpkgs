{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  buildPackages,
  nix-update-script,
  testers,
  az-pim-cli,
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

  vendorHash = "sha256-g4NcRNmHXS3mOtE0nbV96vFFoVzGFbAvcj/vkdXshoU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd az-pim-cli \
        --bash <(${emulator} $out/bin/az-pim-cli completion bash) \
        --fish <(${emulator} $out/bin/az-pim-cli completion fish) \
        --zsh <(${emulator} $out/bin/az-pim-cli completion zsh)
    ''
  );

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "HOME=$TMPDIR az-pim-cli --version";
      package = az-pim-cli;
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
