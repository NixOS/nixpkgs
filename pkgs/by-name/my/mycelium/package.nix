{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "mycelium";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "threefoldtech";
    repo = "mycelium";
    rev = "v${version}";
    hash = "sha256-VWrWg9UpBSug0cvY/zuzGFI6Y0CRFcrh1Cy4mbYtg9Q=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tun-0.6.1" = "sha256-DelNPCOWvVSMS2BNGA2Gw/Mn9c7RdFNR21/jo1xf+xk=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "End-2-end encrypted IPv6 overlay network";
    homepage = "https://github.com/threefoldtech/mycelium";
    changelog = "https://github.com/threefoldtech/mycelium/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "mycelium";
  };
}
