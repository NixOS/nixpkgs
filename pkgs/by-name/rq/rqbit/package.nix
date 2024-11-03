{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-YOjFCX1Ckk0M2QOGoYKoY80TFnHs00aVJJAWv2RIp4A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "network-interface-1.1.1" = "sha256-9fWdR5nr73oFP9FzHhDsbA4ifQf3LkzBygspxI9/ufs=";
    };
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    description = "Bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cafkafk toasteruwu ];
    mainProgram = "rqbit";
  };
}
