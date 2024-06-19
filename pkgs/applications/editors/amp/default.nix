{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, python3, xorg, cmake, libgit2, darwin
, curl }:

rustPlatform.buildRustPackage rec {
  pname = "amp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jmacdonald";
    repo = pname;
    rev = version;
    sha256 = "sha256-xNadwz2agPbxvgUqrUf1+KsWTmeNh8hJIWcNwTzzM/M=";
  };

  cargoHash = "sha256-4c72l3R9OyxvslKC4RrIu/Ka3grGxIUCY6iF/NHS5X8=";

  nativeBuildInputs = [ cmake pkg-config python3 ];
  buildInputs = [ openssl xorg.libxcb libgit2 ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ curl Security AppKit ]);

  # Tests need to write to the theme directory in HOME.
  preCheck = "export HOME=`mktemp -d`";

  meta = with lib; {
    description = "A modern text editor inspired by Vim";
    homepage = "https://amp.rs";
    license = [ licenses.gpl3 ];
    maintainers = [ maintainers.sb0 ];
    platforms = platforms.unix;
    mainProgram = "amp";
  };
}
