{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "v${version}";
    hash = "sha256-UYc7iphpzqZPwhOn/ia7XvnnlIUvM7nSFBz67ZkXmNs=";
  };

  cargoHash = "sha256-982FdK6ej3Bbg4R9e43VSwlni837ZK4rkMkoeYMyW8E=";

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
