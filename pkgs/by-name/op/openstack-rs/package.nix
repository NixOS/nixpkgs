{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openstack-rs";
  version = "0.13.0";
  src = fetchFromGitHub {
    owner = "gtema";
    repo = "openstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ywj0K9MdckVuKxjt1za+IyK4SoeyTXoXbDRXLqEkic0=";
  };

  cargoHash = "sha256-e2wt5BS+RQOpo3T5HOutvKGv4lHiIoTk9tEqMs4f5Dw=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd osc \
      --bash <($out/bin/osc completion bash) \
      --fish <($out/bin/osc completion fish) \
      --zsh <($out/bin/osc completion zsh)
  '';

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenStack CLI and TUI implemented in Rust";
    homepage = "https://github.com/gtema/openstack";
    changelog = "https://github.com/gtema/openstack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "osc";
  };
})
