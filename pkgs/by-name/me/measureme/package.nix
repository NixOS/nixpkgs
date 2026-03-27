{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "measureme";
  version = "12.0.3";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "measureme";
    rev = finalAttrs.version;
    hash = "sha256-pejgWzHtpEBylFzG1+/8zTV7qR6gf6UuTmuH9GNPoD0=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Support crate for rustc's self-profiling feature";
    homepage = "https://github.com/rust-lang/measureme";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.t4ccer ];
  };
})
