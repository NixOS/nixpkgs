{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  rustfmt,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ferrumc";
  version = "0.1.0-rc2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ferrumc-rs";
    repo = "ferrumc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nu3n+oCLABxzbWqyRZRmehLmyuqVeKLZplL0jcVsJn8=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  patches = [
    ./use-cwd-for-data-root.patch
  ];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock

    substituteInPlace src/bin/src/packet_handlers/play_packets/player_command.rs \
      --replace-fail "use tracing::log::trace;" "use tracing::trace;"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    rustfmt
  ];

  # Upstream requires nightly Rust
  env.RUSTC_BOOTSTRAP = 1;

  # The default dashboard downloads its UI during the build
  buildNoDefaultFeatures = true;

  cargoBuildFlags = [
    "--bin"
    "ferrumc"
  ];
  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "ferrumc-dashboard"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "High-performance Minecraft server implementation, crafted in Rust for unparalleled speed and efficiency";
    homepage = "https://github.com/ferrumc-rs/ferrumc";
    changelog = "https://github.com/ferrumc-rs/ferrumc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "ferrumc";
    platforms = lib.platforms.linux;
    knownVulnerabilities = [
      "RUSTSEC-2023-0071: RSA PKCS#1 v1.5 decryption is vulnerable to the Marvin Attack"
    ];
  };
})
