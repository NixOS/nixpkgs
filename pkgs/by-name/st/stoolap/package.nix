{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stoolap";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "stoolap";
    repo = "stoolap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NfGs9TDyX+8hC2bCGJL0AWFd3C1joowT061vea5hxx0=";
  };

  cargoHash = "sha256-tzgxffwXd331Sz1xftXNBowqud29pKvbw+Epv01xOiQ=";

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
