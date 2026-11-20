{
  lib,
  rustPlatform,
  fetchFromGitHub,
  oniguruma,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anchor";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "otter-sec";
    repo = "anchor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YcQWgNeT/2dvU1dnieo42z5VXnZRoZK9PMGmV/rFxFk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    oniguruma
    zstd
  ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

  cargoHash = "sha256-obD/QyRliNheBvcj2islxaZ6RgM60l8O69jLUmxlLyc=";

  # Only build the anchor-cli package
  cargoBuildFlags = [
    "-p"
    "anchor-cli"
  ];

  # Only run tests for the anchor-cli
  cargoTestFlags = [
    "-p"
    "anchor-cli"
  ];

  meta = {
    description = "Solana Sealevel Framework";
    homepage = "https://github.com/otter-sec/anchor";
    changelog = "https://github.com/otter-sec/anchor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      Denommus
      _0xgsvs
    ];
    mainProgram = "anchor";
  };
})
