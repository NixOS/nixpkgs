{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, gmp, ncurses }:

rustPlatform.buildRustPackage rec {
  version = "0.4.4";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "0rvck5ahg7s51fdlr2ch698cwnyc6qp84zhfgs3wkszj9r5j470k";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "1ijfvfhgjgzlpi1hjhy435m7vq568grh84bmkdlj3m83jxjcz874";

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
