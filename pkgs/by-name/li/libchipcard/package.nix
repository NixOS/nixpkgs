{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gwenhywfar,
  pcsclite,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libchipcard";
  version = "5.1.6";
  releaseId = "382";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/libchipcard-${version}.tar.gz";
    hash = "sha256-bAf1J0F/dWIHT5kBLaTRHrTbr9M/SeZrRCzNbjuM/SA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gwenhywfar
    pcsclite
    zlib
  ];

  makeFlags = [ "crypttokenplugindir=$(out)/lib/gwenhywfar/plugins/ct" ];

  meta = {
    description = "Library for access to chipcards";
    homepage = "https://www.aquamaniac.de/rdm/projects/libchipcard";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ aszlig ];
    platforms = lib.platforms.linux;
  };
}
