{ stdenv, rustPlatform, fetchFromGitHub, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nch2p4isdv746p9pczqwram0c5f0f9l2r3fy5r12x9br0kak136";
  };

  cargoSha256 = "1d54afg45lw8zyanr49fklzhczadyja2fjmid22d81s2ari84slz";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
