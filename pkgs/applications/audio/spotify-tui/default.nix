{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "15icg332iyacdn4ydr4nivblayg4xkcnjh4f0sjnhj4q173v8fq2";
  };

  cargoSha256 = "0rw8pj74k88rvcr18837g356lwsn2vdq384yma9df462xd2cw823";

  nativeBuildInputs = [ pkgconfig ] ++ stdenv.lib.optionals stdenv.isLinux [ python3 ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optional stdenv.isLinux libxcb
    ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Security ];

  meta = with stdenv.lib; {
    description = "Spotify for the terminal written in Rust";
    homepage = "https://github.com/Rigellute/spotify-tui";
    changelog = "https://github.com/Rigellute/spotify-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jwijenbergh ];
    platforms = platforms.all;
  };
}
