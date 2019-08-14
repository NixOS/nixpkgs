{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, libuuid, openssl
, tls ? true
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-proxy-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-proxy";
    rev = "v${version}";
    sha256 = "19rv5zmxwr3kmb2m3fas91aq1493cnkhvs88zcflnijr1ra218ks";
  };

  cmakeFlags = []
    ++ lib.optional (!tls) "-DWITH_TLS=OFF"
  ;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd libuuid ]
    ++ lib.optional tls openssl
  ;

  postPatch = ''
    # Set default donation level to 0%. Can be increased at runtime via --donate-level option.
    substituteInPlace src/donate.h \
      --replace "kDefaultDonateLevel = 2;" "kDefaultDonateLevel = ${toString donateLevel};"

    # Link dynamically against libuuid instead of statically
    substituteInPlace CMakeLists.txt --replace uuid.a uuid
  '';

  installPhase = ''
    install -vD xmrig-proxy $out/bin/xmrig-proxy
  '';

  meta = with lib; {
    description = "Monero (XMR) Stratum protocol proxy";
    homepage = "https://github.com/xmrig/xmrig-proxy";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aij ];
  };
}
