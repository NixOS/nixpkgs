{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "0pvgq8r1bb7bdxm50hxl0n7ajplpzp1gnf6j55dn6xwck0syml9y";
  };

  cargoSha256 = "07v1qm5ky99j2lwbl00g80z0f8hfrpwgyqsm8fnda6y9s3vzzdgz";

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
