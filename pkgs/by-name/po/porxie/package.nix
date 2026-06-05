{
  lib,
  fetchFromCodeberg,
  rustPlatform,
  nixosTests,
  stdenvNoCC,
  nix-update-script,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "porxie";
  version = "0.3.3";

  src = fetchFromCodeberg {
    owner = "Blooym";
    repo = "porxie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nB0QbGJ6emO1WLbIYAvCni6Xjs1AgQo8in6Y3Tof01g=";
  };
  cargoHash = "sha256-7iupGBdDvk4hofMVNuVTt67M7EOveYb3hD1mk2BJRbU=";

  buildInputs = [ rust-jemalloc-sys ];

  checkFlags = [
    # Requires network access.
    "--skip=identity_service::tests::resolve_and_cache"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux {
      porxie = nixosTests.porxie;
    };
  };

  meta = {
    description = "Porxie, an ATProto blob proxy for secure content delivery";
    homepage = "https://codeberg.org/Blooym/porxie";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ blooym ];
    mainProgram = "porxie";
    platforms = lib.platforms.unix;
  };
})
