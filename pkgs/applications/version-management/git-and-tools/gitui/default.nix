{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, perl, python3, Security, AppKit, openssl, xclip }:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FRPRkFGf6Z/+smK651wR6ETWrvvQ1AKalxXW6d6otIo=";
  };

  cargoSha256 = "sha256-3ubeZgB7XNKysy6s+cdg4GDj/Mn4Mdp9VupcbBRTRh4=";

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
