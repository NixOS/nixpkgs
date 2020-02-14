{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "06xqj83m4hz00p8796m0df7lv9875p8zc1v6l9yqbiak1h95lq7h";
  };

  legacyCargoFetcher = false;

  cargoSha256 = "1pc4n6lm1w0660ivm0kxzicpckvb351y62dpv0cxa7ckd3raa5pr";

  nativeBuildInputs = [ pkgconfig ] ++ stdenv.lib.optionals stdenv.isLinux [ python3 ];
  buildInputs = [ openssl ]
  	++ stdenv.lib.optional stdenv.isLinux libxcb
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Security ];

  meta = with stdenv.lib; {
    description = "Spotify for the terminal written in Rust";
    homepage = https://github.com/Rigellute/spotify-tui;
    changelog = "https://github.com/Rigellute/spotify-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jwijenbergh ];
    platforms = platforms.all;
  };
}
