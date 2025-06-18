{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  udev,
  stdenv,
  nix-update-script,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "espflash";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    tag = "v${version}";
    hash = "sha256-8qFq+OyidW8Bwla6alk/9pXLe3zayHkz5LsqI3jwgY0=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      udev
    ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-WEPSXgHR7wA2zWbc8ogVxDRtXcmR20R14Qwo2VqPLrQ=";
  checkFlags = [
    "--skip cli::monitor::external_processors"
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
