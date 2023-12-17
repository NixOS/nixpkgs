{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-qjjKS5UaBIGemw3lipTYNn+kmDlF7Yr+uwICw1cnxuE=";
  };

  cargoHash = "sha256-LhVzubfiOq/u46tKFYaxzty5WnLHTP4bnObuNOYRt5A=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    description = "A bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "rqbit";
  };
}
