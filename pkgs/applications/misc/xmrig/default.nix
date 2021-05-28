{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl, hwloc
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  pname = "xmrig";
  version = "5.11.3";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "019g64rp6g0b0w17bm9l4q5lh7szc6ai8r3bfmy98ngi929r4rl7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd openssl hwloc ];

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
    maintainers = with maintainers; [ fpletz kim0 ];
  };
}
