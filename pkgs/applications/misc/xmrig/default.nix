{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "1s6hz9r0079r9sd1wgd1nm6wn1dmix4smz7174g9a29z2zcqr160";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd openssl ];

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
