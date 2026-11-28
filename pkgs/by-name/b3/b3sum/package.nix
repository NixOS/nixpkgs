{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "b3sum";
  version = "1.8.8";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-NriSUP+LGoS0QGqOySv9IJrTbdvLQ7g/CZqIkziAB2U=";
  };

  cargoHash = "sha256-nI3kWjyp8nT8ZNr2ByC0aRNELTEhkdL8OlKnlBGo+1I=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [
      fpletz
    ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${finalAttrs.version}";
  };
})
