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

rustPlatform.buildRustPackage rec {
  pname = "espflash";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    tag = "v${version}";
    hash = "sha256-Ia7o2u7egBTlzQAWnME6+/8V+5Go70wwXi/nJLKbGZM=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ];

  cargoHash = "sha256-Jh5JoHHfbrpwedXHuCBlIJxCTYjKfofjAoWD8QhGSH8=";

  cargoBuildFlags = [
    "--exclude xtask"
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
    changelog = "https://github.com/esp-rs/espflash/blob/v${version}/CHANGELOG.md";
    mainProgram = "espflash";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
