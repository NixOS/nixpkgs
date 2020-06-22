{ stdenv, rustPlatform, fetchFromGitHub, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "14r7ar38h6r992s4mladb0i7af1hzbnb9imhzlik69sjgpkfddwn";
  };

  cargoSha256 = "1m09y037rd7jviivg5hx5112jdgcn3nd7crbrwbf3glrk0mprygp";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with stdenv.lib; {
    description = "Blazing fast terminal-ui for git written in rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
