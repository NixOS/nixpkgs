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

  useFetchCargoVendor = true;
  cargoHash = "sha256-HVYMC6NgkK5FPFetvxRUOHZ/Pn2uMYlF1VQJQXpNh9g=";

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
