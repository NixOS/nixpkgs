{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "snpguest";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "virtee";
    repo = "snpguest";
    tag = "v${version}";
    hash = "sha256-Fu8A3n1vzA8y5ccyo785udOTTqumLQWCOy0RL/mQ/us=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6AXpdm4Ge8j8w74YGEQYpj6r8gKp+Bim/6xA2WLjSC0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for interacting with SEV-SNP guest environment";
    homepage = "https://github.com/virtee/snpguest";
    changelog = "https://github.com/virtee/snpguest/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "snpguest";
    platforms = [ "x86_64-linux" ];
  };
}
