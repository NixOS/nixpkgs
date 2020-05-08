{ stdenv, rustPlatform, fetchFromGitHub, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ln959zsdn0w15kfyp5i4524hzzk23l31n9smi1md4jfj7jycbh1";
  };

  cargoSha256 = "128g23pcccy07jcb4phlfag9ixh5fkwkaiyd7mxjh3wmhppjcx0i";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
