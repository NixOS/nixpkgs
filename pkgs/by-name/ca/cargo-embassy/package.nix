{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  version = "0.3.4";
in
rustPlatform.buildRustPackage {
  pname = "cargo-embassy";
  inherit version;

  src = fetchFromGitHub {
    owner = "adinack";
    repo = "cargo-embassy";
    tag = "${version}";
    hash = "sha256-/v4qgoXHkhJyD22GG0sRR32CcEYNOhmCSG5qDS7Csk4=";
  };

  # Upstream doesn't commit Cargo.lock
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Command line tool for creating Embassy projects";
    homepage = "https://github.com/adinack/cargo-embassy";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.samw ];
    mainProgram = "cargo-embassy";
  };
}
