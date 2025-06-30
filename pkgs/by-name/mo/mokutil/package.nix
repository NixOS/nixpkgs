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

stdenv.mkDerivation rec {
  pname = "mokutil";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "lcp";
    repo = "mokutil";
    rev = version;
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

  meta = with lib; {
    homepage = "https://github.com/lcp/mokutil";
    description = "Utility to manipulate machines owner keys";
    mainProgram = "mokutil";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.linux;
  };
}
