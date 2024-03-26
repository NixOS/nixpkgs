{
  lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
, udev
, stdenv
, Security
, nix-update-script
, openssl
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "espflash";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espflash";
    rev = "v${version}";
    hash = "sha256-Nv2/33VYpCkPYyUhlVDYJR1BkbtEvEPtmgyZXfVn1ug=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [
    udev
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    SystemConfiguration
  ];

  cargoHash = "sha256-Xj5FVTssC3e+mMhDHmKqV6lUQgaIv3aVc1yewbQSy9E=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd espflash \
      --bash <($out/bin/espflash completions bash) \
      --zsh <($out/bin/espflash completions zsh) \
      --fish <($out/bin/espflash completions fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Serial flasher utility for Espressif SoCs and modules based on esptool.py";
    homepage = "https://github.com/esp-rs/espflash";
    changelog = "https://github.com/esp-rs/espflash/blob/v${version}/CHANGELOG.md";
    mainProgram = "espflash";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
