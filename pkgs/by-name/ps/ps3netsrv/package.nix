{
  lib,
  stdenv,
  fetchzip,
  mbedtls,
  meson,
  ninja,
}:
let
  webManModVersion = "1.47.42";
in
stdenv.mkDerivation rec {
  pname = "ps3netsrv";
  version = "20220813";

  src = fetchzip {
    url = "https://github.com/aldostools/webMAN-MOD/releases/download/${webManModVersion}/${pname}_${version}.zip";
    hash = "sha256-ynFuCD+tp8E/DDdB/HU9BCmwKcmQy6NBx26MKnP4W0o=";
  };

  sourceRoot = "./source/${pname}";

  buildInputs = [
    meson
    ninja
    mbedtls
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Doff64_t=off_t";

  postInstall = ''
    install -Dm644 ../LICENSE.TXT $out/usr/share/licenses/${pname}/LICENSE.TXT
  '';

  meta = with lib; {
    description = "PS3 Net Server (mod by aldostools)";
    homepage = "https://github.com/aldostools/webMAN-MOD/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ makefu ];
    mainProgram = "ps3netsrv";
  };
}
