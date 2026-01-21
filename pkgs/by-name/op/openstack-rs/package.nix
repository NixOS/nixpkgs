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
  version = "0.13.3";
  src = fetchFromGitHub {
    owner = "gtema";
    repo = "openstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F9ePn+Fu9/9/rQnF0a+ViezsMtxuojycF4h9e77tm1Y=";
  };

  cargoHash = "sha256-nVR0XUjOwiYNEYG/6ViH4biCXyeK5GVkMb/uOvBRFUw=";

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
