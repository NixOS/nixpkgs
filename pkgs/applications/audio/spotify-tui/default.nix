{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "1bdcfkfbvvn262p4j0nb4kvjzzgrvn3kxlif48yipqkkykzsgz6g";
  };

  cargoSha256 = "13v2ilmfs9468kavlx6wrsp0dscppxbxgygwpdd35p5hq3vnhl7k";

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
