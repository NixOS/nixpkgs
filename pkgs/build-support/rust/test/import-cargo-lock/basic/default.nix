{ lib, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "basic";
  version = "0.1.0";

  src = ./package;

  cargoLock = {
    lockFile = ./package/Cargo.lock;
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/basic
  '';
}
