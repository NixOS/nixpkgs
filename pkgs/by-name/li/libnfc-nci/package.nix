{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  config,
  debug ? config.libnfc-nci.debug or false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnfc-nci";
  version = "2.4.1-unstable-2024-08-05";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = "linux_libnfc-nci";
    rev = "7ce9c8aad0e37850a49b6d8dcc22ae5c783268e7";
    sha256 = "sha256-iSvDiae+A2hUok426Lj5TMn3Q9G+vH1G0jajP48PehQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--enable-i2c"
  ]
  ++ lib.optionals debug [
    "--enable-debug"
  ];
  dontStrip = debug;

  postInstall = ''
    rm -rf $out/etc
  '';

  meta = {
    description = "Linux NFC stack for NCI based NXP NFC Controllers";
    homepage = "https://github.com/NXPNFCLinux/linux_libnfc-nci";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stargate01 ];
    platforms = lib.platforms.linux;
  };
})
