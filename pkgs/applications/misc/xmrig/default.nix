{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl, hwloc
, donateLevel ? 0
}:

stdenv.mkDerivation rec {
  pname = "xmrig";
  version = "6.18.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "sha256-vYXDQSEhPi/jxCO6pxOJ1q0AoBVVRU9vErtJLq90ltk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libuv libmicrohttpd openssl hwloc ];

  inherit donateLevel;

  patches = [ ./donate-level.patch ];
  postPatch = ''
    substituteAllInPlace src/donate.h
  '';

  installPhase = ''
    install -vD xmrig $out/bin/xmrig
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ kim0 ];
  };
}
