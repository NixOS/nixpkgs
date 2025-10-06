{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rops";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "gibbz00";
    repo = "rops";
    tag = version;
    hash = "sha256-wwZ/4yOB4pE6lZgX8ytCC3plMYt6kxOakQoLy8SWN+k=";
  };

  cargoHash = "sha256-sKPVdvMoQ2nV29rjau/6YpO1zpAQOuZhouPCvDf2goc=";

  # will true when tests is fixed from source.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SOPS alternative in pure rust";
    homepage = "https://gibbz00.github.io/rops";
    changelog = "https://github.com/gibbz00/rops/blob/${version}/CHANGELOG.md";
    mainProgram = "rops";
    maintainers = with lib.maintainers; [ r17x ];
    license = lib.licenses.mpl20;
  };
}
