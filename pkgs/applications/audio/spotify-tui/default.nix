{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "1pshwn486msn418dilk57rl9471aas0dif765nx1p9xgkrjpb7wa";
  };

  cargoSha256 = "0020igycgikkbd649hv6xlpn13dij4g7yc43fic9z710p6nsxqaq";

  nativeBuildInputs = [ pkgconfig ] ++ stdenv.lib.optionals stdenv.isLinux [ python3 ];
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
