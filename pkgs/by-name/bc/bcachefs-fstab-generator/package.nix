{
  rustPlatform,
  pkg-config,
  systemd,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "bcachefs-fstab-generator";
  version = "0.1.0-unstable-2024-11-02";

  src = fetchFromGitHub {
    owner = "ElvishJerricco";
    repo = "bcachefs-fstab-generator";
    rev = "c98b7dd19a1ffda0e3137e417822e3d79e208f5f";
    hash = "sha256-WeZZ96fq9aQ+OMfpj5yqk2X+qthLJGgITg9cV7VOD7o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-W9p8EEluU0+BSz3zR1LuQ6IgVYaZtuaIfpM4BDRH0WM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];
}
