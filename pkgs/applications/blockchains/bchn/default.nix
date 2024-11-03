{ fetchFromGitLab
, stdenv
, boost
, libevent
, miniupnpc
, help2man
, db62
, openssl
, zeromq
, cmake
, git
, python3
, libsForQt5
, lib
}:

stdenv.mkDerivation rec {
  name = "bchn";
  version = "24.0.0";
  src = fetchFromGitLab {
    owner = "bitcoin-cash-node";
    repo = "bitcoin-cash-node";
    rev = "v${version}";
    sha256 = "sha256-5n7hqyyclj3fSaF3RBW1EQ3fO42n5biFSTvBRr3GN5c=";
  };
  buildInputs = [ boost libevent miniupnpc openssl zeromq db62 ];
  nativeBuildInputs = [ cmake git python3 ];

  # This can probably be supported, but I can't invest time into it right now.
  cmakeFlags = [ "-DBUILD_BITCOIN_QT=OFF" "-DENABLE_MAN=OFF" ];
  postConfigure = ''
    chmod +x config/run_native_cmake.sh src/secp256k1/build_native_gen_context.sh
  '';

  meta = with lib; {
    description = "A professional, miner-friendly node that solves practical problems for Bitcoin Cash";
    homepage = "https://bitcoincashnode.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}
