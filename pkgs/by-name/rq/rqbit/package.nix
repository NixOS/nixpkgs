{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-r/ff/Z/nsmQEWCVvmS0hGKXRuzIoDGhzfIRAxC6EaZk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "network-interface-1.1.1" = "sha256-9fWdR5nr73oFP9FzHhDsbA4ifQf3LkzBygspxI9/ufs=";
    };
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    description = "A bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "rqbit";
  };
}
