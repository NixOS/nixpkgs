{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rusty-rain";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "cowboy8625";
    repo = "rusty-rain";
    rev = "v${version}";
    hash = "sha256-d5rvmJs77LW7eFpDZqpLG+IbNpdOUKLSGcpqlEWKJHk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "A cross platform matrix rain made with Rust";
    homepage = "https://github.com/cowboy8625/rusty-rain";
    changelog = "https://github.com/cowboy8625/rusty-rain/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adam-gaia ];
    mainProgram = "rusty-rain";
  };
}
