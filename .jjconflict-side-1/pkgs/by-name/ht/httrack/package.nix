{
  lib,
  stdenv,
  fetchurl,
  zlib,
  openssl,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httrack";
  version = "3.50.3";

  src = fetchurl {
    url = "https://github.com/xroche/httrack/releases/download/${finalAttrs.version}/httrack-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZE1OwOSK1ZbazX+AF7aNij8d/BQChLQStTCG59FmTp0=";
  };

  buildInputs = [
    libiconv
    openssl
    zlib
  ];

  meta = {
    description = "Easy-to-use offline browser / website mirroring utility";
    homepage = "https://www.httrack.com";
    changelog = "https://github.com/xroche/httrack/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = with lib.platforms; unix;
  };
})
