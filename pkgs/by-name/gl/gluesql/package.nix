{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gluesql";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "gluesql";
    repo = "gluesql";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z2fpyPJfyPtO13Ly7XRmMW3rp6G3jNLsMMFz83Wmr0E=";
  };

  cargoHash = "sha256-QITNkSB/IneKj0w12FCKV1Y0vRAlOfENs8BpFbDpK2M=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust library for SQL databases";
    homepage = "https://github.com/gluesql/gluesql";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.all;
  };
})
