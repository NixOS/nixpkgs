{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "degit-rs";
  version = "0.1.3-unstable";

  src = fetchFromGitHub {
    owner = "psnszsn";
    repo = "degit-rs";
    rev = "c7dbeb75131510a79400838e081b90665c654c80";
    hash = "sha256-swyfKnYQ+I4elnDnJ0yPDUryiFXEVnrGt9xHWiEe6wo=";
  };

  sourceRoot = finalAttrs.src.name;

  postPatch = ''
    # The source repo doesn't provide a Cargo.lock file, so we need to create one
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoHash = "sha256-bUoZsXU7iWK7MZ/hXk1JNUX1hN88lrU1mc1rrYuiCYs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # The test suite is not working for it requires network connections,
  # so we skip it
  doCheck = false;

  meta = {
    description = "Rust rewrite of degit";
    homepage = "https://github.com/psnszsn/degit-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "degit";
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
