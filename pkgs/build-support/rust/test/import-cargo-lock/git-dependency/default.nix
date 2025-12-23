{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "git-dependency";
  version = "0.1.0";

  src = ./package;

  cargoLock = {
    lockFile = ./package/Cargo.lock;
    outputHashes = {
      "rand-0.8.3" = "0ya2hia3cn31qa8894s3av2s8j5bjwb6yq92k0jsnlx7jid0jwqa";
    };
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/git-dependency
  '';
}
