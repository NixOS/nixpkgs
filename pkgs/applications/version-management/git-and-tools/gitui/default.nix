{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, perl, python3, Security, AppKit, openssl, xclip }:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UM1L95VKmUh2E56dlKo3TkNYRlib5Hg5VHGokBqTP+s=";
  };

  cargoSha256 = "sha256-i/Z1pOrg7rKH5uDqkyh7V9jZRHXZ3Bhhw5UpzKWOjJ0=";

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
