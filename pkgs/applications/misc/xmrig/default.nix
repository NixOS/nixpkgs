{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "09dcjvnm74j1d26mvdiz0sl1qwns5xfkdwx46nqd4xlgvg9x4rpx";
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
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ fpletz ];
  };
}
