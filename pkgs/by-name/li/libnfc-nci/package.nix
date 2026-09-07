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
  version = "2.4.1-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "StarGate01";
    repo = "linux_libnfc-nci";
    rev = "1ed3cced60d3c7c5bb08486d54db322ac099a3dd";
    sha256 = "sha256-eIYey7N3CWomEDYQ8OVdx/f6vZN+TavYhNMiYh5KJPo=";
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
