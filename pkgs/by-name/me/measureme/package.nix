{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "measureme";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "measureme";
    rev = version;
    hash = "sha256-Zgl8iyBDVwqZnbfqC06DMuo0S/hV6pl812hkiovmS+I=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Support crate for rustc's self-profiling feature";
    homepage = "https://github.com/rust-lang/measureme";
    license = licenses.asl20;
    maintainers = [ maintainers.t4ccer ];
  };
}
