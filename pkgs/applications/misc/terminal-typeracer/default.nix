{ stdenv
, fetchFromGitLab
, rustPlatform
, pkg-config
, openssl
, sqlite
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "terminal-typeracer";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "ttyperacer";
    repo = pname;
    rev = "v${version}";
    sha256 = "187xrqxalk2gxa22ki5q092llvliddrsc68cg4dvvy2xzq254jfy";
  };

  cargoSha256 = "0ky8m23fjjbv7fr9776fjczpg0d43jxwnjxjpwz56jpynwnihfkl";

  buildInputs = [ openssl sqlite ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];
  nativeBuildInputs = [ pkg-config ];

  meta = with stdenv.lib; {
    description = "An open source terminal based version of Typeracer written in rust";
    homepage = "https://gitlab.com/ttyperacer/terminal-typeracer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ yoctocell ];
    platforms = platforms.x86_64;
  };
}
