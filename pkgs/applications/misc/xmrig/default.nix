{ stdenv, lib, fetchFromGitHub, cmake, hwloc, libuv, libmicrohttpd, openssl
, donateLevel ? 0
, http ? false
, tls ? true
, algo ? ["cryptonight-lite" "cryptonight-heavy" "cryptonight-pico" "cryptonight-gpu" "randomx"]
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "1m0rsjb7y1j77mzg5cqb3fdvzgvjkrwgmkjn9nv1xl2757z8hcl4";
  };

  cmakeFlags = []
    ++ lib.optional (!http) "-DWITH_HTTP=OFF"
    ++ lib.optional (!tls) "-DWITH_TLS=OFF"
    ++ lib.optional ((lib.count(a: a == "cryptonight-lite")  algo) == 0) "-DWITH_CN_LITE=OFF"
    ++ lib.optional ((lib.count(a: a == "cryptonight-heavy") algo) == 0) "-DWITH_CN_HEAVY=OFF"
    ++ lib.optional ((lib.count(a: a == "cryptonight-pico")  algo) == 0) "-DWITH_CN_PICO=OFF"
    ++ lib.optional ((lib.count(a: a == "cryptonight-gpu")   algo) == 0) "-DWITH_CN_GPU=OFF"
    ++ lib.optional ((lib.count(a: a == "randomx")           algo) == 0) "-DWITH_RANDOMX=OFF"
  ;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ hwloc libuv openssl ]
    ++ lib.optional http libmicrohttpd
    ++ lib.optional tls openssl
  ;

  postPatch = ''
    substituteInPlace src/donate.h \
      --replace "kDefaultDonateLevel = 5;" "kDefaultDonateLevel = ${toString donateLevel};" \
      --replace "kMinimumDonateLevel = 1;" "kMinimumDonateLevel = ${toString donateLevel};"
  '';

  installPhase = ''
    install -vD xmrig $out/bin/xmrig
  '';

  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ fpletz ];
  };
}
