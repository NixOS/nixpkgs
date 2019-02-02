{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, gmp, ncurses }:

rustPlatform.buildRustPackage rec {
  version = "0.4.4";
  name = "rink-${version}";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "0rvck5ahg7s51fdlr2ch698cwnyc6qp84zhfgs3wkszj9r5j470k";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "0xmmxm7zwmq7w0pspx17glg4mjgh9l61w0h2k7n97x6p35i198d1";

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ openssl gmp ncurses ];

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Unit-aware calculator";
    homepage = http://rink.tiffnix.com;
    license = with licenses; [ mpl20 gpl3 ];
    maintainers = [ maintainers.sb0 ];
  };
}
