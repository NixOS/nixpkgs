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
  version = "0.10.0";

  src = fetchFromCodeberg {
    owner = "heiko";
    repo = "rsop";
    rev = "rsop/v${finalAttrs.version}";
    hash = "sha256-UEXSYfbbnEV0GL0Q6wFNoERWp3jjEZ2ia/UhOGo1dn8=";
  };

  cargoHash = "sha256-Sa9ZRUsTLXLYQJYmGhkMqnWTHey5shy/w0l90xa+ck8=";

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
