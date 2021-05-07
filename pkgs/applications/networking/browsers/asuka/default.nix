{ lib, stdenv, rustPlatform, fetchFromSourcehut, pkg-config, ncurses, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "asuka";
  version = "0.8.1";

  src = fetchFromSourcehut {
    owner = "~julienxx";
    repo = pname;
    rev = version;
    sha256 = "1y8v4qc5dng3v9k0bky1xlf3qi9pk2vdsi29lff4ha5310467f0k";
  };

  cargoSha256 = "0b8wf12bjsy334g04sv3knw8f177xsmh7lrkyvx9gnn0fax0lmnr";

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
