{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "0pgmcld48sd34jpsc4lr8dbqs8iwk0xp9aa3b15m61mv3lf04qc6";
  };

  cargoSha256 = "1rb4dl9zn3xx2yrapx5cfsli93ggmdq8w9fqi8cy8giyja1mnqfl";

  cargoPatches = [ ./fix-cargo-lock-version.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Spotify for the terminal written in Rust";
    homepage = https://github.com/Rigellute/spotify-tui;
    license = licenses.mit;
    maintainers = with maintainers; [ jwijenbergh ];
    platforms = platforms.all;
  };
}
