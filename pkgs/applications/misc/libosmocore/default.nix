{ lib, stdenv
, autoreconfHook
, fetchFromGitHub
, gnutls
, libmnl
, libusb1
, lksctp-tools
, pcsclite
, pkg-config
, python3
, talloc
}:

stdenv.mkDerivation rec {
  pname = "libosmocore";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
    hash = "sha256-AjOyZiLlXhsetbyMBuUssoNxk22LzGOkZpeLt4vKli4=";
  };

  propagatedBuildInputs = [
    talloc
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    gnutls
    libmnl
    libusb1
    lksctp-tools
    pcsclite
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of Osmocom core libraries";
    homepage = "https://github.com/osmocom/libosmocore";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
