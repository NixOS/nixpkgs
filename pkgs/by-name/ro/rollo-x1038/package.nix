{
  stdenv,
  cups,
  lib,
  fetchzip,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rollo-x1038";
  version = "1.8.4";
  src = fetchzip {
    url = "https://rollo-main.b-cdn.net/driver-dl/linux/rollo-cups-driver-${finalAttrs.version}.tar.gz";
    hash = "sha256-BJ6yj59MiLMfbEkf+Ud4ypDWgskxjrXHJCfZIrlpDXU=";
  };
  nativeBuildInputs = [
    pkg-config
    cups
  ];
  buildInputs = [
    cups
  ];
  makeFlags = [
    "CUPS_SERVERBIN=$(out)/lib/cups"
    "CUPS_DATADIR=$(out)/share/cups"
    "CUPS_SERVERROOT=$(out)/etc/cups"
  ];
  meta = {
    description = "CUPS Linux drivers for the Rollo X1038 thermal label printer";
    downloadPage = "https://www.rollo.com/driver-linux/";
    homepage = "https://www.rollo.com/product/rollo-printer/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ChocolateLoverRaj ];
    license = lib.licenses.gpl3Only;
  };
})
