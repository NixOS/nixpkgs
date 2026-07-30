{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  nixfmt,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nil";
  version = "2026-07-23";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = "nil";
    rev = finalAttrs.version;
    hash = "sha256-upJVI2pq9sOKgF2AILt8l6O4/3GNcMtT/s0rmnbO5UA=";
  };

  cargoHash = "sha256-ZyTrxGX0mRdskxp4o5ssDCyZzNn36rIgP9fDaA1fDws=";

  nativeBuildInputs = [ nix ];

  env = {
    CFG_RELEASE = finalAttrs.version;
    CFG_DEFAULT_FORMATTER = lib.getExe nixfmt;
  };

  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      oxalica
    ];
    mainProgram = "nil";
  };
})
