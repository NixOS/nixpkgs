{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, libuuid, openssl
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-proxy-${version}";
  version = "2.14.4";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-proxy";
    rev = "v${version}";
    sha256 = "11q4w5ncyyf2vgrb64zlr01n3adyaxja2pcqm5id9if0nvwwn4ga";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd libuuid openssl ];

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
