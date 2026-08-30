{
  lib,
  fetchCrate,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "b3sum";
  version = "1.8.7";

  src = fetchCrate {
    inherit (finalAttrs) version pname;
    hash = "sha256-ZShgvrxccsaLXKl0wMF5GfpRzjlBi/ideUQSW+nQg5k=";
  };

  cargoHash = "sha256-aPFihFEmGDkAAd5fLcHQ0elpOR+KOmhZi28QxR7aQ8Q=";

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
