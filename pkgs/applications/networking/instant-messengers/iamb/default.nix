{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, darwin
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "iamb";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "ulyssa";
    repo = "iamb";
    rev = "v${version}";
    hash = "sha256-Mt4/UWySC6keoNvb1VDCVPoK24F0rmd0R47ZRPADkaw=";
  };

  cargoHash = "sha256-UbmeEcmUr3zx05Hk36tjsl0Y9ay7DNM1u/3lPqlXN2o=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  postInstall = ''
    OUT_DIR=$releaseDir/build/iamb-*/out
    installManPage $OUT_DIR/iamb.{1,5}
  '';

  meta = with lib; {
    description = "A Matrix client for Vim addicts";
    homepage = "https://github.com/ulyssa/iamb";
    changelog = "https://github.com/ulyssa/iamb/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ meain ];
  };
}
