{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "1jc6vzqdl85pmiw5qv9b148kfw4k4wxn90ggylxfpfdv7czamh2c";
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
