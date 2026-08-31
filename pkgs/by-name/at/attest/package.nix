{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "attest";
  version = "0.5.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "attest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fc/kzBKuaTIZQd/RD3xWyZfpzP9eMER0FnBgouJVVZM=";
  };

  cargoHash = "sha256-RN8L5HlYshgmfEqkHAfLAnHZVqWlQ4YDyQXfICg/Dtg=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "attest";
    description = "Dead simple test framework for the age of AI";
    homepage = "https://github.com/fossable/attest";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
