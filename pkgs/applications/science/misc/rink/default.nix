{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, gmp, ncurses }:

rustPlatform.buildRustPackage rec {
  version = "0.4.5";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "0vl996y58a9b62d8sqrpfn2h8qkya7qbg5zqsmy7nxhph1vhbspj";
  };

  # Upstreamed in https://github.com/tiffany352/rink-rs/pull/53
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0shlh0m9k0iqxpv9zmiw7a6v197swrvpz9x6qzhximzkdwni9gz9";

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ openssl gmp ncurses ];

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Unit-aware calculator";
    homepage = "http://rink.tiffnix.com";
    license = with licenses; [ mpl20 gpl3 ];
    maintainers = with maintainers; [ sb0 filalex77 ];
  };
}
