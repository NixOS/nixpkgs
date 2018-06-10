{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, libuuid
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-proxy-${version}";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig-proxy";
    rev = "v${version}";
    sha256 = "1yfbdgyd37r5vb2g8jz4i92hxang3hbiig5y4507v9hr75jvfivh";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd libuuid ];

  # Set default donation level to 0%. Can be increased at runtime via --donate-level option.
  postPatch = ''
    substituteInPlace src/donate.h --replace "kDonateLevel = 2;" "kDonateLevel = ${toString donateLevel};"
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
