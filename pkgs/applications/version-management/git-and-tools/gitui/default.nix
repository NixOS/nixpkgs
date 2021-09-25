{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, perl, python3, Security, AppKit, openssl, xclip, pkg-config }:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dRHlbxNV4nS50WbJP5lD1zB7NkZmv7nlPUm3RlQIBtc=";
  };

  cargoSha256 = "sha256-9uRvxax0SrvRkD89mbZPxsfRItde11joA/ZgnXK9XBE=";

  nativeBuildInputs = [ python3 perl pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux xclip
    ++ lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
