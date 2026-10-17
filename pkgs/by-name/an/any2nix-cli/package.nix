{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "any2nix-cli";
  version = "0.1.4";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "gbr-ufs";
    repo = "any2nix";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-nL07U3D3TS6gz1/yRVrk7Zb7hHdDEB4vVBuRHLlA2xo=";
  };
  cargoHash = "sha256-hkk5gnRl+H/RxrbTAouqDqZhv8yttbWXwFD/F01JdIg=";
  buildAndTestSubdir = "any2nix-cli";
  nativeBuildInputs = [
    installShellFiles
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  postInstall = ''
    $out/bin/any2nix --man > any2nix.1
    installManPage any2nix.1
    installShellCompletion --cmd any2nix \
      --bash <($out/bin/any2nix --completions bash) \
      --zsh <($out/bin/any2nix --completions zsh) \
      --fish <($out/bin/any2nix --completions fish)
  '';
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Command-line interface for translating from various formats to Nix.";
    homepage = "https://github.com/gbr-ufs/any2nix";
    changelog = "https://github.com/gbr-ufs/any2nix/raw/${finalAttrs.pname}-v${finalAttrs.version}/${finalAttrs.pname}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
    ];
    mainProgram = "any2nix";
    maintainers = with lib.maintainers; [
      gbr-ufs
    ];
  };
})
