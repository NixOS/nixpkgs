{
  rustPlatform,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage {
  pname = "git-dependency-rev-non-workspace-nested-crate";
  version = "0.1.0";

  src = ./package;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  cargoLock = {
    lockFile = ./package/Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.1.0" = "1yy1y1d523xdzwg1gc77pigbcwsbawmy4b7vw8v21m7q957sk0c4";
    };
  };

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/git-dependency-rev-non-workspace-nested-crate
  '';
}
