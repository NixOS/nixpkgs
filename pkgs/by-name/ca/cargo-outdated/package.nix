{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-outdated";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = "cargo-outdated";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V4zNFi/ZU98egCElU/dDLQZm/8f6oyvbeQYn7JFraDs=";
  };

  cargoHash = "sha256-51UjhAC2boNgW5kc7WxZOxcnXirw1E07CjLRcj/GEOM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
