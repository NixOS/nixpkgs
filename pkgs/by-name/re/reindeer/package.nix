{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reindeer";
  version = "2026.10.12.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r2BkgXiuFwI7E5cHQjNs9Rl+EaSMLeFOlWyXMSL1zSM=";
  };

  cargoHash = "sha256-Ow9cfa/9oRQJU56Nt6812ThNlapn1on+g1wU+uc6s0g=";
  cargoPatches = [
    # The 2026.10.12.00 release omits this registry checksum from Cargo.lock,
    # which Nix's Cargo vendor fetcher requires.
    ./missing-registry-checksum.patch
  ];
  patches = [
    # Avoid lowering the existing soft limit when increase_nofile_limit clamps
    # to kern.maxfilesperproc on macOS; also handle limit-query failures without
    # panicking during startup.
    ./fix-rlimit-lowering.patch
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Buck build rules from Rust Cargo dependencies";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amaanq ];
  };
})
