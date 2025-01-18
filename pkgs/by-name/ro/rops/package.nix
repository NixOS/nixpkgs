{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rops";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "gibbz00";
    repo = "rops";
    tag = version;
    hash = "sha256-532rV7ISNy8vbqq8yW9FdIqj5Ei/HJKZoEocM7Vwvg8=";
  };

  cargoHash = "sha256-7+SAaIw2B+Viu3lBN+yQq5VDEC9o4THQ1LRiQ8QmnaU=";

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
