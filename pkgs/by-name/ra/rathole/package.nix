{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  rustc,
  pkg-config,
  openssl,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "rathole";
  version = "0.5.0-unstable-2024-06-06";

  src = fetchFromGitHub {
    owner = "rapiz1";
    repo = "rathole";
    rev = "be14d124a22e298d12d92e56ef4fec0e51517998";
    hash = "sha256-C0/G4JOZ4pTAvcKZhRHsGvlLlwAyWBQ0rMScLvaLSuA=";
  };

  # Get rid of git dependency on vergen. No reason to require libgit2-sys as
  # well as libz-sys. Vendored c libraries for libgit2/zlib fail to build on
  # darwin and using libs from nixpkgs seems excessive.
  patches = [
    ./0001-no-more-vergen.patch
  ];

  # Build script is only needed for vergen and does nothing when not in a git
  # repo.
  postPatch = ''
    rm build.rs
  '';

  cargoHash = "sha256-IgPDe8kuWzJ6nF2DceUbN7fw0eGkoYhu1IGMdlSMFos=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ openssl ];
  preCheck = ''
    patchShebangs examples/tls/create_self_signed_cert.sh
    (cd examples/tls && chmod +x create_self_signed_cert.sh && ./create_self_signed_cert.sh)
  '';

  env = {
    VERGEN_BUILD_TIMESTAMP = "0";
    VERGEN_BUILD_SEMVER = version;
    VERGEN_GIT_COMMIT_TIMESTAMP = "0";
    VERGEN_GIT_BRANCH = "main";
    VERGEN_RUSTC_SEMVER = rustc.version;
    VERGEN_RUSTC_CHANNEL = "stable";
    VERGEN_CARGO_PROFILE = "release";
    VERGEN_CARGO_FEATURES = "";
    VERGEN_CARGO_TARGET_TRIPLE = "${stdenv.hostPlatform.rust.rustcTarget}";
  };

  passthru.tests = {
    inherit (nixosTests) rathole;
  };

  meta = {
    description = "Reverse proxy for NAT traversal";
    homepage = "https://github.com/rapiz1/rathole";
    license = lib.licenses.asl20;
    mainProgram = "rathole";
    maintainers = with lib.maintainers; [
      dit7ya
      xokdvium
    ];
  };
}
