{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  pcsclite,
  nix-update-script,
  testers,
  rsop,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsop";
  version = "0.11.0";

  src = fetchFromCodeberg {
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${finalAttrs.version}";
    hash = "sha256-vZW4L3hm2vRRoLcxU631jiNrbk+w0hDaL4VXIrtP2aY=";
  };

  cargoHash = "sha256-qrurMKwSs0w2D6KPto7tpsuLGuAJ9drKhdmIAbEaD9M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pcsclite ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "rsop version";
      package = rsop;
    };
  };

  meta = {
    homepage = "https://codeberg.org/heiko/rsop";
    description = "Stateless OpenPGP (SOP) based on rpgp";
    license = with lib.licenses; [
      mit
      apsl20
      cc0
    ];
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "rsop";
  };
})
