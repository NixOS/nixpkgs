{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  libiconv,
  autoreconfHook,
  autoconf-archive,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.49.14";
  pname = "httrack";

  src = fetchFromGitHub {
    owner = "xroche";
    repo = "httrack";
    tag = finalAttrs.version;
    hash = "sha256-NP4i77DzD+4S0C8kpKPUX3EHfy4zAQoaXsYNmdHsbrQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [
    libiconv
    openssl
    zlib
  ];

  meta = {
    description = "Easy-to-use offline browser / website mirroring utility";
    homepage = "https://www.httrack.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = with lib.platforms; unix;
  };
})
