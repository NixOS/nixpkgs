{ stdenv, rustPlatform, fetchFromGitHub, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lxpdwpxizc4bczh5cl2x2xbbdam3fakvgcbbrdh43czgjwb4ds1";
  };

  cargoSha256 = "14x0m3pq4gapgqaljxdwmr5pk9h209ls95an9xgrq0dj6apyimgx";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
