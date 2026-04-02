{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stoolap";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "stoolap";
    repo = "stoolap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TE16vsLzhwmqZRZrmWx8ikv2HJbB4sAXaKSPPNsMeLw=";
  };

  cargoHash = "sha256-ZWu1uu607n3wl3k7xcpS7cHbX7mifAX9gvo8KQmCB/E=";

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
