{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  stdenv,
  nix-update-script,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "espflash";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CeXkC+3M22EmHG0KL0wMXn49bUbxgD33ojQvbeaf5Gs=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ];

  cargoHash = "sha256-Vgf3k0pT8VswESXuWIIeZlCFLm861BYrteRFkmhk/3M=";

  cargoBuildFlags = [
    "--exclude=xtask"
    "--workspace"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd espflash \
      --bash <($out/bin/espflash completions bash) \
      --zsh <($out/bin/espflash completions zsh) \
      --fish <($out/bin/espflash completions fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Serial flasher utility for Espressif SoCs and modules based on esptool.py";
    homepage = "https://github.com/esp-rs/espflash";
    changelog = "https://github.com/esp-rs/espflash/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "espflash";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
