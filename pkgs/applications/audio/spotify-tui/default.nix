{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.5.0";
  
  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}"; 
    sha256 = "1spnr67fb2wjjf9sfkk3vps6q45w0zrk47an79bhv4imziy4dbs3";
  };

  cargoSha256 = "029g80mcqvmckszpbzm4hxs5w63n41ah4rc1b93i9c1nzvncd811";

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
