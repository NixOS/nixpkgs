{
  fetchFromGitHub,
  lib,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netui";
  version = "0.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "valeninki";
    repo = "netui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Riyk9X5CGQWra8wJ5VQpGEUMAqi7b7ltOgnKgnM98jU=";
  };

  cargoHash = "sha256-PRXxnDgFOyG5KHxcCrB/SfJzooQfOTIeYkZ2J7pfC1g=";

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Lightweight TUI network manager for IWD, systemd-networkd, and systemd-resolved";
    homepage = "https://github.com/valeninki/netui";
    changelog = "https://github.com/valeninki/netui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valeninki ];
    mainProgram = "netui";
    platforms = lib.platforms.linux;
  };
})
