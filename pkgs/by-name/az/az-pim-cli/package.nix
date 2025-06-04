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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "netr0m";
    repo = "az-pim-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gf4VscHaUr3JtsJO5PAq1nyPeJxIwGPaiH/QdXKpvQ0=";
  };

  vendorHash = "sha256-PHrpUlAG/PBe3NKUGBQ1U7dCcqkSlErWX2dp9ZPB3+8=";

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
