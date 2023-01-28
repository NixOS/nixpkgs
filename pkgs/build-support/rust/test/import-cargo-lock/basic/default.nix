{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "basic";
  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/basic
  '';
}
