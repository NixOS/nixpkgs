{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl, hwloc
, writeText
, configFile ? null
, donateLevel ? 0
}:

let
  configFileWriteCommand = if configFile != null then ''
    echo "${configFile}" > $out/bin/config.json
  '' else "";
in
stdenv.mkDerivation rec {
  pname = "xmrig";
  version = "6.14.0";

  src = fetchFromGitHub {
    owner = "xmrig";
    repo = "xmrig";
    rev = "v${version}";
    sha256 = "sha256-h+Y7hXkenoLT83eG0w6YEfOuEocejXgvqRMq1DwWwT0=";
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
  '' + configFileWriteCommand;

  meta = with lib; {
    description = "Monero (XMR) CPU miner";
    homepage = "https://github.com/xmrig/xmrig";
    license = licenses.gpl3Plus;
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ fpletz kim0 ];
  };
}
