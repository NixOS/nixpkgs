{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "1f9z9akgaf27r5hjrsjw0clk47p7igi0slbg7z6c3rvy5q9kq0wp";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd ];

  postPatch = ''
    substituteInPlace src/donate.h --replace "kDonateLevel = 5;" "kDonateLevel = ${toString donateLevel};"
  '';

  installPhase = ''
    install -vD xmrig $out/bin/xmrig
  '';

  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}
