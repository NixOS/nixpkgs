{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  pcsclite,
  nix-update-script,
  testers,
  rsop,
  stdenv, # for meta.broken
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rsop";
  version = "0.11.5";

  src = fetchFromCodeberg {
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${finalAttrs.version}";
    hash = "sha256-4Qw6iRGqgVCuIkqdwcY0KPe/W+kdGDV+1xAXOrhd14Y=";
  };

  cargoHash = "sha256-X/4Sp1zkTz6luj8IXYYXOEGraFVKUfgPjm/N14O4n8o=";

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
      asl20
      cc0
    ];
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "rsop";
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
  };
})
