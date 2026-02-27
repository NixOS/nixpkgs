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
  version = "0.15.0+2026021301.0.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "oxide.rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PFcQ4zNLh1Q5wMgBeWptix9+ii4TY2RtnI6JIyMYa14=";
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

  cargoHash = "sha256-Yf5PG5jRoufP+rf3WHCwT3zvDp++68Ewl2KFTCO5w54=";

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
