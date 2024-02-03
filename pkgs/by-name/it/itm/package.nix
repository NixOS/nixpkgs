{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "itm";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rtic-scope";
    repo = pname;
    rev = "ae87f0e6c161d94a9f10420362344deabeba0736";
    sha256 = "0cyik1dm80llvv22kivrjc50mdrch7m2q2jsp4r3xxxsadk9g87h";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cortex-m-0.7.4" = "sha256-EqXHntEgAO5qiWOidcy44u0Jo3aSH9oW2H91xf18yLc=";
      "nix-0.23.1" = "sha256-X7Sza6Rw2GQoGk6MIJmJqoZFp4oIkZmNhS82V4I28O4=";
    };
  };

  nativeBuildInputs = [pkg-config];

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    mainProgram = "itm-decode";
    description = "ARMv7-M ITM packet protocol decoder library crate and CLI tool";
    homepage = "https://github.com/rtic-scope/itm";
    license = with lib.licenses; [asl20 mit];
    maintainers = with lib.maintainers; [
      marshmallow
    ];
  };
}
