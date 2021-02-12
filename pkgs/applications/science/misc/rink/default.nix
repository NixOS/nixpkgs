{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses }:

rustPlatform.buildRustPackage rec {
  version = "0.5.1";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "1s67drjzd4cf93hpm7b2facfd6y1x0s60aq6pygj7i02bm0cb9l9";
  };

  cargoSha256 = "0x9x0fag20469pak32110vfvfpk98zfwazc5bknzgaq1msx8i8l8";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ncurses ];

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3 ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
