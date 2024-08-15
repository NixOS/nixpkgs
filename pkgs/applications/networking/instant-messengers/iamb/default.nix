{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
  version = "0.0.9-unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "54cb7991be526e2b8cd45e0a5b7cdb4a6d2e310b";
    hash = "sha256-CepMojqLh0VUnHkagMKGHnEJfA8/EIoGBVN2rRNyFko=";
  };

  cargoHash = "sha256-MBi6R/hyIvPvTet4IohgFWgRZQQTnxuS2JV3kfqxoyA=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  postInstall = ''
    OUT_DIR=$releaseDir/build/iamb-*/out
    installManPage $OUT_DIR/iamb.{1,5}
  '';

  meta = with lib; {
    description = "Matrix client for Vim addicts";
    mainProgram = "iamb";
    homepage = "https://github.com/ulyssa/iamb";
    changelog = "https://github.com/ulyssa/iamb/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ meain ];
  };
}
