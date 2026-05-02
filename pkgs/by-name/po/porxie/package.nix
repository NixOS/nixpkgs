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
  version = "0.2.0";

  src = fetchFromCodeberg {
    owner = "Blooym";
    repo = "porxie";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BLlsvzmAQj/N1pmw+ZMBmC48O4SPvvLWDD198ihXR+k=";
  };
  cargoHash = "sha256-4gRC7ZXok9oshUCkDBhxtbnxma224smaL4GcCgdCkSc=";

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
