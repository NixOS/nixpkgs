{ stdenv, rustPlatform, fetchurl, pkgconfig, ncurses, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "asuka";
  version = "0.8.0";

  src = fetchurl {
    url = "https://git.sr.ht/~julienxx/${pname}/archive/${version}.tar.gz";
    sha256 = "10hmsdwf2nrsmpycqa08vd31c6vhx7w5fhvv5a9f92sqp0lcavf0";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0csj63x77nkdh543pzl9cbaip6xp8anw0942hc6j19y7yicd29ns";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ ncurses openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Gemini Project client written in Rust with NCurses";
    homepage = "https://git.sr.ht/~julienxx/asuka";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
