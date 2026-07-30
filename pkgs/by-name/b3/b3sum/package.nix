{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "b3sum";
  version = "1.8.5";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-odlO6J60wTrca+opzheDbz4lSDAgjDTFFUIHf6NoTXI=";
  };

  cargoHash = "sha256-a/KGCU0bZ1gqB8EH7f8SN6qTuYZMakXdqddtTKNVDPs=";

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
