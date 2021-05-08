{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, perl, python3, Security, AppKit, openssl, xclip }:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KJXYkOHR50Zap0Ou+jVi09opHuZBfHN/ToZbasZ3IE4=";
  };

  cargoSha256 = "sha256-N6Yr+TqxWwl/6SgjizIyZJoVsjn/R9yjxUKCqwt8UJg=";

  nativeBuildInputs = [ python3 perl ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux xclip
    ++ lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  meta = with lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
