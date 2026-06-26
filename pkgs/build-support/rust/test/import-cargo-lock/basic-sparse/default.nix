{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "basic-sparse";
  version = "0.1.0";

  src = ./package;

  cargoLock = {
    lockFile = ./package/Cargo.lock;
    extraRegistries = {
      "sparse+https://index.crates.io/" = "https://static.crates.io/crates";
    };
  };

  doInstallCheck = true;
  postConfigure = ''
    cargo metadata --offline
  '';
  installCheckPhase = ''
    $out/bin/basic-sparse
  '';
}
