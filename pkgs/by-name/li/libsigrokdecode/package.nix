{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  autoreconfHook,
  glib,
  python3,
  check,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "libsigrokdecode";
  version = "0.5.3-unstable-2023-10-23";

  src = fetchgit {
    url = "git://sigrok.org/libsigrokdecode";
    rev = "0c35c5c5845d05e5f624c99d58af992d2f004446";
    hash = "sha256-1kQB7uk2c+6Uriw+1o6brThDcBLoCdPV0MVWAha7ohk=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    glib
    python3
    libxcrypt
  ];
  nativeCheckInputs = [ check ];
  doCheck = true;

  meta = with lib; {
    description = "Protocol decoding library for the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      bjornfor
      vifino
    ];
  };
}
