{ stdenv, rustPlatform, fetchFromGitHub, libiconv, perl, python3, Security, AppKit, openssl, xclip }:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yq98jslbac87zdzlwqc2kcd6hqy2wnza3l8n3asss1iaqcb0ilh";
  };

  cargoSha256 = "16riggrhk1f6lg8y46wn89ab5b1iz6lw00ngid20x4z32d2ww70f";

  nativeBuildInputs = [ python3 perl ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optional stdenv.isLinux xclip
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
