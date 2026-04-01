{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "b3sum";
  version = "1.8.4";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-xqR2BPtuAhsVvLY2DXfmgRF3tLix+H8lcD9GSZh9pUg=";
  };

  cargoHash = "sha256-h/M9SOyl9Dj9QNvKyxtg0L0mNYBhH7Q4Yke5n20SSSs=";

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
