{ lib, stdenv, rustPlatform, fetchFromSourcehut, pkg-config, ncurses, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "asuka";
  version = "0.8.5";

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = pname;
    rev = version;
    sha256 = "sha256-+rj6P3ejc4Qb/uqbf3N9MqyqDT7yg9JFE0yfW/uzd6M=";
  };

  cargoHash = "sha256-XrFpvH3qiMvpgbH7Q+KC1zFAqJT4rjxux6Q5KLY2ufI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.hostPlatform.isDarwin Security;

  meta = with lib; {
    description = "Gemini Project client written in Rust with NCurses";
    mainProgram = "asuka";
    homepage = "https://git.sr.ht/~julienxx/asuka";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
