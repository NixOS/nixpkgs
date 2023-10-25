{ lib
, stdenv
, fetchurl
, SDL
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "tinyemu";
  version = "2019-12-21";

  src = fetchurl {
    url = "https://bellard.org/tinyemu/${pname}-${version}.tar.gz";
    hash = "sha256-voNR8hIYGbMXL87c5csYJvoSyH2ht+2Y8mnT6AKgVVU=";
  };

  buildInputs = [
    SDL
    curl
    openssl
  ];

  makeFlags = [
    "CC:=$(CC)"
    "STRIP:=$(STRIP)"
    "DESTDIR=$(out)"
    "bindir=/bin"
  ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  meta = with lib; {
    homepage = "https://bellard.org/tinyemu/";
    description = "A system emulator for the RISC-V and x86 architectures";
    longDescription = ''
      TinyEMU is a system emulator for the RISC-V and x86 architectures. Its
      purpose is to be small and simple while being complete.
    '';
    license = with licenses; [ mit bsd2 ];
    maintainers = with maintainers; [ jhhuh AndersonTorres ];
    platforms = platforms.linux;
  };
}
