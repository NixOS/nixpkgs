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
  version = "0.12.1";
  src = fetchFromGitHub {
    owner = "gtema";
    repo = "openstack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jJNEZF0aGD4pdKWdWOa64nIr/CKJlBL7Vo9MFiQ54xo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-edKIJM4FQ/SmR7IU/7WxNm+hHouXMWUV8n3rbKzvV0A=";

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
