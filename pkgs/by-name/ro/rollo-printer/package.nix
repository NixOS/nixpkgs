{
  cups,
  fetchurl,
  lib,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rollo-printer";
  version = "1.8.4";

  src = fetchurl {
    url = "https://rollo-main.b-cdn.net/driver-dl/linux/rollo-cups-driver-${finalAttrs.version}.tar.gz";
    hash = "sha256-v61/5HY25cvhVbHF+dXOOGrDfZZzvvicJEy7MKTAG10=";
  };

  nativeBuildInputs = [ cups ];

  buildInputs = [ cups ];

  makeFlags = [
    "CUPS_DATADIR=${placeholder "out"}/share/cups"
    "CUPS_SERVERBIN=${placeholder "out"}/lib/cups"
  ];

  meta = {
    description = "CUPS driver for Rollo label printers";
    homepage = "https://www.rollo.com/driver-linux/";
    license = with lib.licenses; gpl3Plus;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = cups.meta.platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
