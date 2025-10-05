{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "git-dependency-tag";
  version = "0.1.0";

  src = ./package;

  cargoLock = {
    lockFile = ./package/Cargo.lock;
    outputHashes = {
      "rand-0.8.3" = "0l3p174bpwia61vcvxz5mw65a13ri3wy94z04xrnyy5lzciykz4f";
    };
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/git-dependency-tag
  '';
}
