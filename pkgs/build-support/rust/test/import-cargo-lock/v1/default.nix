{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "v1";
  version = "0.1.0";

  src = ./package;

  cargoLock = {
    lockFile = ./package/Cargo.lock;
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/v1
  '';
}
