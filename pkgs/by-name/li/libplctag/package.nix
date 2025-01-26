{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libplctag";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "libplctag";
    repo = "libplctag";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HUog7Tlm4jiqYXk22dziumCA/68c35+OwnTNYu9mV5E=";
  };

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=int-conversion"
    ];
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/libplctag/libplctag";
    description = "Library that uses EtherNet/IP or Modbus TCP to read and write tags in PLCs";
    license = with lib.licenses; [
      lgpl2Plus
      mpl20
    ];
    maintainers = with lib.maintainers; [ petterstorvik ];
    platforms = lib.platforms.all;
  };
})
