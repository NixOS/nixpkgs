{
  lib,
  fetchFromGitHub,

  rustPlatform,

  pcsclite,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "age-plugin-openpgp-card";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "wiktor-k";
    repo = "age-plugin-openpgp-card";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JTZs4kJCi3O3QIlqFz7VPbAlqDqRhfs2b/fHKMd5zKg=";
  };

  cargoHash = "sha256-pOcjSB+N9u72sfZaAoTNsKQC0lCCX0TWhwN6dLGJ2wk=";

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
      "aarch64-darwin"
    ];
    mainProgram = "age-plugin-openpgp-card";
    maintainers = with lib.maintainers; [ nukdokplex ];
  };
})
