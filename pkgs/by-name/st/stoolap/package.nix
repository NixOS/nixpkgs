{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stoolap";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "stoolap";
    repo = "stoolap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xL0MFxtIqSsQh5SDEvIsJgBi/o/To0oht8ZjdEFJX7Q=";
  };

  cargoHash = "sha256-edWMWY0gBjDNroJ9qm6u7krTy1lskD4s9aSS8jEN/MM=";

  # On aarch64-darwin, dev target needs to set panic strategy to abort
  # However this must be set while the flag `-Zpanic_abort_tests` is also set,
  # which could only be done in Rust nightly toolchain.
  doCheck = !(with stdenv.hostPlatform; isDarwin && isAarch64);

  meta = {
    description = "Modern Embedded SQL Database written in Rust";
    homepage = "https://stoolap.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "stoolap";
  };
})
