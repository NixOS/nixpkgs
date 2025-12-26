{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "basic-dynamic";
  version = "0.1.0";

  src = ./package;

  cargoLock.lockFileContents = builtins.readFile ./package/Cargo.lock;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/basic-dynamic
  '';
}
