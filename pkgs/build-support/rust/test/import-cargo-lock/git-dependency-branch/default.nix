{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "git-dependency-branch";
  version = "0.1.0";

  src = ./package;

  cargoLock = {
    lockFile = ./package/Cargo.lock;
    outputHashes = {
      "rand-0.8.4" = "1ilk9wvfw3mdm57g199ys8f5nrgdrh0n3a4c8b7nz6lgnqvfrv6z";
    };
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/git-dependency-branch
  '';
}
