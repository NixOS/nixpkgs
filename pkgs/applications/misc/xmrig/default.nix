{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  name = "xmrig-${version}";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "144i24c707fja89iqcc511b4077p53q8w2cq5zd26hry2i4i3abi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd openssl ];

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
