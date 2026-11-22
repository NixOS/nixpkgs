{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  efivar,
  keyutils,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mokutil";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "lcp";
    repo = "mokutil";
    rev = finalAttrs.version;
    sha256 = "sha256-1UNIy1zw3H2FPU1qAb1hn08TQ+EkMeR4wMbicXnsU2A=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    efivar
    keyutils
    libxcrypt
  ];

  meta = {
    homepage = "https://github.com/lcp/mokutil";
    description = "Utility to manipulate machines owner keys";
    mainProgram = "mokutil";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.linux;
  };
})
