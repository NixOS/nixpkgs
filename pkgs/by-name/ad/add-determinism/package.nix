{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  zlib,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "add-determinism";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "keszybz";
    repo = "add-determinism";
    tag = "v${version}";
    hash = "sha256-jUBHIdqPuK95jNNMFeSgj0xd3WSneqRa0kcVDhFC3aw=";
  };

  # this project has no Cargo.lock now
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = !stdenv.hostPlatform.isDarwin; # it seems to be running forever on darwin

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
  ];

  meta = {
    description = "Build postprocessor to reset metadata fields for build reproducibility";
    homepage = "https://github.com/keszybz/add-determinism";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      Emin017
      sharzy
    ];
    platforms = lib.platforms.all;
    mainProgram = "add-determinism";
  };
}
