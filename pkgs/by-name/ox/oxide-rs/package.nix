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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxide-rs";
  version = "0.16.0+2026032500.0.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "oxide.rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0zlH7Gws7Cn161whwx4myBF1wTL46fFcr0mjPrvCTmQ=";
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

  cargoHash = "sha256-x6jYTwrfdAKl42AleIYXxWLjnwi1IYMtWnfosueiHp0=";

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
})
