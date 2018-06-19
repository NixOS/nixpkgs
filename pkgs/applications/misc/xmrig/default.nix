{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "1ssiq2yv8b3xg4kfp2cfzl41m5apjw2r2k74lh3fz0g0ix3cq55b";
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
