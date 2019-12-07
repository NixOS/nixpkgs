{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "10wrlfi50lsf6qjsi9qklw2mk2fbf0jib7f841v842l9k9zw0hrg";
  };

  cargoSha256 = "140m3pryvbc96xvl5ymz68msrx93rmvvy0y8skvc40yxwl401inc";

  nativeBuildInputs = [ pkgconfig python3 ];
  buildInputs = [ openssl ]
  	++ stdenv.lib.optional stdenv.isLinux libxcb
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Security ];

  meta = with stdenv.lib; {
    description = "Spotify for the terminal written in Rust";
    homepage = https://github.com/Rigellute/spotify-tui;
    license = licenses.mit;
    maintainers = with maintainers; [ jwijenbergh ];
    platforms = platforms.all;
  };
}
