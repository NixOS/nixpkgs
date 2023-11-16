{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rqbit";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-9yYHxlvRlO8iJ3SPi0+4lEgBgAaqaDffKChqAe4OsYU=";
  };

  cargoHash = "sha256-dUQiW6J3Wycp5D3mAwGwruU6CkQ534OyP1GdsY7jzEw=";

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
