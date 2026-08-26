{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
  zlib,
  zstd,
  ...
}:
stdenv.mkDerivation rec {
  pname = "greptimedb";
  version = "1.0.0-rc.1";

  src = fetchurl {
    url = "https://github.com/GreptimeTeam/greptimedb/releases/download/v${version}/greptime-linux-amd64-v${version}.tar.gz";
    hash = "sha256-xitwxtDeWe/xSlOKVZPKaSe5hKTiFavjiyjFCwVvdTE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    zlib
    zstd
    stdenv.cc.cc.lib
  ];

  sourceRoot = "greptime-linux-amd64-v${version}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 greptime $out/bin/greptime

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cloud-native, unified observability database for metrics, logs and traces";
    homepage = "https://greptime.com";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "greptime";
  };
}
