{ stdenv, rustPlatform, fetchFromGitHub, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rdaschf6030zprz81g7xnx57idjsq3bjhjp5d9387ha5njq0bp1";
  };

  cargoSha256 = "1k24xabhgwwdvslq81w6b8jnnjxbafj4s0zpcq2c4hals2xxwfy4";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
