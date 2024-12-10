{
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "dummyhttp";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "dummyhttp";
    rev = "v${version}";
    hash = "sha256-MDkyJAVNpCaAomAEweYrQeQWtil8bYo34ko9rAu+VBU=";
  };

  cargoHash = "sha256-JkA0qW/MQH+XmiD9eiT0s70HxNNYyk9ecBo4k5nUF10=";

  buildInputs = lib.optionals stdenv.isDarwin [
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
