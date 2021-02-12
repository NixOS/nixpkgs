{ lib, stdenv, rustPlatform, fetchFromGitHub, libiconv, perl, python3, Security, AppKit, openssl, xclip }:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yq98jslbac87zdzlwqc2kcd6hqy2wnza3l8n3asss1iaqcb0ilh";
  };

  cargoSha256 = "14k2hjgyxdn1a1b5zldi457yjqli65lm89715as4df5y8z6jshxb";

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
