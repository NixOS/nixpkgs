{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses }:

rustPlatform.buildRustPackage rec {
  version = "0.5.0";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "1z51n25hmgqkn4bm9yj18j8p4pk5i1x3f3z70vl1vx3v109jhff0";
  };

  cargoSha256 = "0p63py8q4iqj5rrsir9saj7dvkrafx63z493k7p5xb2mah7b21lb";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ncurses ];

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3 ];
    maintainers = with maintainers; [ sb0 filalex77 ];
  };
}
