{
  cups,
  fetchurl,
  lib,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rollo-printer";
  version = "1.8.4";

  src = fetchurl {
    url = "https://rollo-main.b-cdn.net/driver-dl/linux/rollo-cups-driver-${finalAttrs.version}.tar.gz";
    hash = "sha256-v61/5HY25cvhVbHF+dXOOGrDfZZzvvicJEy7MKTAG10=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ cups ];

  # configure unconditionally derives CUPS_DATADIR/CUPS_SERVERBIN from
  # pkg-config, which points into the cups store path; override at make time
  # so the filter and PPD are installed into $out instead.
  makeFlags = [
    "CUPS_DATADIR=${placeholder "out"}/share/cups"
    "CUPS_SERVERBIN=${placeholder "out"}/lib/cups"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "CUPS driver for Rollo label printers";
    homepage = "https://www.rollo.com/driver-linux/";
    license = with lib.licenses; gpl3Plus;
    maintainers = with lib.maintainers; [ shymega ];
    platforms = cups.meta.platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
