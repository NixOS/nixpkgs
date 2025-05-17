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
  version = "0.11.1+20250409.0.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "oxide.rs";
    rev = "v${version}";
    hash = "sha256-4WPeK576/9F+GfcH4NReux4Ogmw0/tUSBpF76eNxQP8=";
    # leaveDotGit is necessary because `build.rs` expects git information which
    # is used to write a `built.rs` file which is read by the CLI application
    # to display version information.
    leaveDotGit = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aE0Pofj6hlSafduMgdu3JzhHiYadmWXopK8O2x6Q3TM=";

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
