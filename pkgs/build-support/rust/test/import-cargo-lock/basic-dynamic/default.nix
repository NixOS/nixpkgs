{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "basic-dynamic";
  version = "0.1.0";

  src = ./.;

  cargoLock.lockFileContents = builtins.readFile ./Cargo.lock;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/basic-dynamic
  '';
}
