{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "oxide-rs";
  version = "0.9.0+20241204.0.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "oxide.rs";
    rev = "v${version}";
    hash = "sha256-NtTXpXDYazcXilQNW455UDkqMCFzFPvTUkbEBQsWIDo=";
    # leaveDotGit is necessary because `build.rs` expects git information which
    # is used to write a `built.rs` file which is read by the CLI application
    # to display version information.
    leaveDotGit = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-We5yNF8gtHWAUAead0uc99FIoMcicDWdGbTzPgpiFyY=";

  cargoPatches = [
    ./0001-use-crates-io-over-git-dependencies.patch
  ];

  cargoBuildFlags = [
    "--package=oxide-cli"
    "--package=xtask"
  ];

  cargoTestFlags = [
    "--package=oxide-cli"
  ];

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "The Oxide Rust SDK and CLI";
    homepage = "https://github.com/oxidecomputer/oxide.rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      djacu
      sarcasticadmin
    ];
    mainProgram = "oxide";
  };
}
