{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnutls,
  openssl,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "librelp";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "rsyslog";
    repo = "librelp";
    rev = "v${version}";
    sha256 = "sha256-VWW5EM1INxBACoQsIN+mxsJjUKDFbfh2mqdvB/3W6Xw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    gnutls
    zlib
    openssl
  ];

  meta = with lib; {
    description = "Reliable logging library";
    homepage = "https://www.librelp.com/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
