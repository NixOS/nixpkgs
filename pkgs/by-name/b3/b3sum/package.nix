{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "b3sum";
  version = "1.8.6";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-VWYsN/kNK/aR/Qc9nsTaXuJMO4PNBNOT6cfzwleKhD0=";
  };

  cargoHash = "sha256-KOzFTLgbmrzUV5KmqJV9N7GUsUhaM3cwSxi/WlkeQBM=";

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
