{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "measureme";
  version = "12.0.1";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "measureme";
    rev = version;
    hash = "sha256-G6GCXMyjwx1yYuCwSRj8j76zLKShtPFfQmTQnnqpMlk=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Support crate for rustc's self-profiling feature";
    homepage = "https://github.com/rust-lang/measureme";
    license = licenses.asl20;
    maintainers = [ maintainers.t4ccer ];
  };
}
