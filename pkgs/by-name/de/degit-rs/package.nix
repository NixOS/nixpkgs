{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage {
  pname = "degit-rs";
  version = "0.1.2-unstable-2021-09-22";

  src = fetchFromGitHub {
    owner = "psnszsn";
    repo = "degit-rs";
    rev = "c7dbeb75131510a79400838e081b90665c654c80";
    hash = "sha256-swyfKnYQ+I4elnDnJ0yPDUryiFXEVnrGt9xHWiEe6wo=";
  };

  # The source repo doesn't provide a Cargo.lock file, so we need to create one
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  cargoHash = "sha256-bUoZsXU7iWK7MZ/hXk1JNUX1hN88lrU1mc1rrYuiCYs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # The test suite is not working for it requires a network connection,
  # so we disable it
  doCheck = false;

  meta = {
    description = "Rust rewrite of degit";
    homepage = "https://github.com/psnszsn/degit-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "degit";
    maintainers = with lib.maintainers; [ chillcicada ];
  };
}
