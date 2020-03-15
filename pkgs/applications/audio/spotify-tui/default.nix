{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "0fmj25zjg12v0kyanic343lrdhxkh290v88qiz6ac47g8bdy3c83";
  };

  cargoSha256 = "1n8aacy0hapjm10hmgqm07rb5c0ngmzr1s116pspsl7cdszza6xi";

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
