{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.49.6";
  pname = "httrack";

  src = fetchFromGitHub {
    owner = "xroche";
    repo = "httrack";
    # 3.49.6 is not tagged, but corresponds to this rev.
    rev = "748c35de7858ead963daf1393ad023d75b7820c2";
    hash = "sha256-Iaeo6lB84I0amr2C8iZ+kQ6F8AXqyyARV6FiwpBshvA=";
    fetchSubmodules = true;
  };

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
