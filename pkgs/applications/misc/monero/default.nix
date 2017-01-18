{ stdenv, fetchFromGitHub, cmake, boost, miniupnpc, pkgconfig, unbound }:

let
  version = "0.10.1";
in
stdenv.mkDerivation {
  name = "monero-${version}";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    sha256 = "1zngskpgxz3vqq348h0mab2kv95z6g9ckvqkr77mx15m5z3qi6aw";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ boost miniupnpc unbound ];

  # these tests take a long time and don't
  # always complete in the build environment
  postPatch = "sed -i '/add_subdirectory(tests)/d' CMakeLists.txt";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  doCheck = false;

  installPhase = ''
    install -Dt "$out/bin/" \
        bin/monerod \
        bin/monero-blockchain-export \
        bin/monero-blockchain-import \
        bin/monero-utils-deserialize \
        bin/monero-wallet-cli \
        bin/monero-wallet-rpc
  '';

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage = https://getmonero.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = [ "x86_64-linux" ];
  };
}
