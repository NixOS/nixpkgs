{ lib, stdenv, rustPlatform, fetchFromSourcehut, pkg-config, ncurses, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "asuka";
  version = "0.8.3";

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = pname;
    rev = version;
    sha256 = "sha256-l3SgIyApASllHVhAc2yoUYc2x7QtCdzBrMYaXCp65m8=";
  };

  cargoSha256 = "sha256-twECZM1KcWeQptLhlKlIz16r3Q/xMb0e+lBG+EX79mU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Gemini Project client written in Rust with NCurses";
    homepage = "https://git.sr.ht/~julienxx/asuka";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
