{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agenix-cli";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "cole-h";
    repo = "agenix-cli";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-eJp6t8h8uOP0YupYn8x6VAAmUbVrXypxNMGx4SK/6d8=";
  };

  cargoHash = "sha256-2xTkCdWKQVg8Sp0LDkC/LH9GYBXNpxdoLX30Ndz0muM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Companion tool to https://github.com/ryantm/agenix";
    homepage = "https://github.com/cole-h/agenix-cli";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ misuzu ];
    mainProgram = "agenix";
  };
})
