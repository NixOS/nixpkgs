{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "librespeed-rust";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "librespeed";
    repo = "speedtest-rust";
    tag = "v${version}";
    hash = "sha256-TINIKZefT4ngnEtlMjxO56PrQxW5gyb1+higiSnkE3Q=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  # Remove vendored lockfile once <https://github.com/librespeed/speedtest-rust/pull/29> lands.
  cargoLock.lockFile = ./Cargo.lock;

  postInstall = ''
    cp -r assets $out/
  '';

  meta = {
    description = "Very lightweight speed test implementation in Rust";
    homepage = "https://github.com/librespeed/speedtest-rust";
    license = lib.licenses.lgpl3Plus;
    teams = with lib.teams; [ c3d2 ];
    mainProgram = "librespeed-rs";
  };
}
