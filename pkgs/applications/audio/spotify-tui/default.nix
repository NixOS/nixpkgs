{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "1gdsk620md5nv1r05jysmfhpbcidh15wzyiklkazsb6cppm6qsiy";
  };

  cargoSha256 = "0irfdmik6nrpfs9yzva5q351cfyf1cijxa2a08prwdccrivdk98a";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkgconfig python3 ];
  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ openssl libxcb ]
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
