{ rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "basic-sparse";
  version = "0.1.0";

  src = ./package;

  cargoHash = "sha256-HYkIKsBXiMx630KFIVOBIkL2TwVWRcNj6DuVdYWcQ8U=";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/basic-sparse
  '';
}
