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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "keszybz";
    repo = "add-determinism";
    tag = "v${version}";
    hash = "sha256-QFhed8YTgvfm6bB/cRsrnN0foplJhK1b9IYD9HGdJUc=";
  };

  # this project has no Cargo.lock now
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  patches = [
    # fix MetadataExt imports for macOS builds, will be removed when the PR is merged:
    # https://github.com/keszybz/add-determinism/pull/48
    (fetchpatch {
      url = "https://github.com/Emin017/add-determinism/commit/0c6c4d1c78c845ab6b6b0666aee0e2dc85492205.patch";
      sha256 = "sha256-y5blOfQuZ5GMug4cDkDDKc5jaGgQEYtLTuuLl041sZs=";
    })
  ];

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
