{
  lib,
  fetchFromGitHub,

  rustPlatform,

  pcsclite,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "age-plugin-openpgp-card";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "wiktor-k";
    repo = "age-plugin-openpgp-card";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z1Q1Sg6qcQwhNDI6dCMf4BejZn5K9VzqLCVvkisB//k=";
  };

  cargoHash = "sha256-MrtCm41Q/Zs3FZCkdsNX30vFFuxIHNHHz4fbhMXuxD4=";

  buildInputs = [ pcsclite ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Age plugin for using ed25519 on OpenPGP Card devices (Yubikeys, Nitrokeys)";
    homepage = "https://github.com/wiktor-k/age-plugin-openpgp-card";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "age-plugin-openpgp-card";
    maintainers = with lib.maintainers; [ nukdokplex ];
  };
})
