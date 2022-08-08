{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "zee";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "zee-editor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/9SogKOaXdFDB+e0//lrenTTbfmXqNFGr23L+6Pnm8w=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;

  # disable downloading and building the tree-sitter grammars at build time
  # grammars can be configured in a config file and installed with `zee --build`
  # see https://github.com/zee-editor/zee#syntax-highlighting
  ZEE_DISABLE_GRAMMAR_BUILD=1;

  cargoSha256 = "sha256-mbqI1csnU95VWgax4GjIxB+nhMtmpaeJ8QQ3qb0hY4c=";

  meta = with lib; {
    description = "A modern text editor for the terminal written in Rust";
    homepage = "https://github.com/zee-editor/zee";
    license = licenses.mit;
    maintainers = with maintainers; [ booklearner ];
  };
}
