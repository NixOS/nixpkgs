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
  version = "0.13.0+20250730.0.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "oxide.rs";
    rev = "v${version}";
    hash = "sha256-baEXsDzM4y4HmUwjIqVBJm+8L+q+llq9g2o1kEZU3vI=";
  };

  patches = [
    # original patch: https://git.iliana.fyi/nixos-configs/tree/packages/oxide-git-version.patch?id=0e4dc0d21def9084e2c6c1e20f3da08c31590945
    ./rm-built-ref-head-lookup.patch
    ./rm-commit-hash-in-version-output.patch
  ];

  checkFlags = [
    # skip since output check includes git commit hash
    "--skip=cmd_version::version_success"
    # skip due to failure with loopback on debug
    "--skip=test_cmd_auth_debug_logging"
  ];

  cargoHash = "sha256-radMOVLnHaV+5bUYanw5mswGM9A+xqNN/a4boe1jWDM=";

  cargoBuildFlags = [
    "--package=oxide-cli"
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
    description = "Oxide Rust SDK and CLI";
    homepage = "https://github.com/oxidecomputer/oxide.rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      djacu
      sarcasticadmin
    ];
    mainProgram = "oxide";
  };
}
