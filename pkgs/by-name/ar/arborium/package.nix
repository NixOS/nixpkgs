{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arborium";
  version = "2.4.5";

  src = fetchCrate {
    inherit (finalAttrs) version;
    pname = "arborium-cli";
    hash = "sha256-ANrR02kRYQEW/Q/ZqiU0tNZOaYWzrcfBlkcZVas24rU=";
  };

  cargoHash = "sha256-PND0pPJhaysL0g2poiPIOC9jLdb1AeIaNqX5rp9XLcA=";

  meta = {
    description = "A terminal-friendly syntax highlighter powered by Tree-sitter";
    mainProgram = "arborium";
    homepage = "https://arborium.bearcove.eu";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ GoldsteinE ];
  };
})
