{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rops";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "gibbz00";
    repo = "rops";
    tag = finalAttrs.version;
    hash = "sha256-f5TSDBUq7c6/zvAcPvriQegI15v0LtAR6scwsCEHStE=";
  };

  cargoHash = "sha256-cSxPt4TQULewx9UdbDHP8YS+EY2C+pRBP8k3AmfcueM=";

  # will true when tests is fixed from source.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SOPS alternative in pure rust";
    homepage = "https://gibbz00.github.io/rops";
    changelog = "https://github.com/gibbz00/rops/blob/${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "rops";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mpl20;
  };
})
