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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "lcp";
    repo = "mokutil";
    rev = finalAttrs.version;
    sha256 = "sha256-DO3S1O0AKoI8gssnUyBTRj5lDNs6hhisc/5dTIqmbzM=";
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
