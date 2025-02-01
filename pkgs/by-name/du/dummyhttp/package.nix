{
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "dummyhttp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    rev = "v${version}";
    hash = "sha256-LgOIL4kg3cH0Eo+Z+RGwxZTPzCNSGAdKT7N8tZWHSQQ=";
  };

  cargoHash = "sha256-bw0VlPHjNZkpLVJZrB3aaQGkwvQpkJGIn+hi0yn2M4s=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Super simple HTTP server that replies a fixed body with a fixed response code";
    homepage = "https://github.com/svenstaro/dummyhttp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ GuillaumeDesforges ];
    mainProgram = "dummyhttp";
  };
}
