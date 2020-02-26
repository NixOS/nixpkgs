{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "19mnnpsidwr5y6igs478gfp7rq76378f66nzfhj4mraqd2jc4nzj";
  };

  cargoSha256 = "1zhv3sla92z7pjdnf0r4x85n7z9spi70vgy4kw72rdc5v9bmj7q8";

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
