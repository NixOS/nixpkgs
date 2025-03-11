{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "koto-ls";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "koto-lang";
    repo = "koto-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6a8xckgpz2/Eb0mQ3ZUL7ywmHA69RMXar/55LUu1UWk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-sDgLvZcLW2lC0fCMOdSX2OvaqOG1GMfQiwAPit6L2/g=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for Koto";
    homepage = "https://github.com/koto-lang/koto-ls";
    changelog = "https://github.com/koto-lang/koto-ls/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "koto-ls";
  };
})
