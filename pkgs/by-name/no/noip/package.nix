{
  lib,
  rustPlatform,
  fetchurl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "noip";
  version = "3.3.0";

  src = fetchurl {
    url = "https://dmej8g5cpdyqd.cloudfront.net/downloads/noip-duc_${finalAttrs.version}.tar.gz";
    hash = "sha256-e50Wv0dF4/8zp/z2Xp9x4YYWIbAcQ8U8OXoNAE/1ADA=";
  };

  cargoHash = "sha256-IX1VrUvix50fFW9Pr6VxrpIhBBTkUuoNH+lXnA41I/4=";

  meta = {
    description = "Dynamic DNS daemon for no-ip accounts";
    homepage = "http://noip.com/download?page=linux";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.iand675 ];
    platforms = lib.platforms.linux;
    mainProgram = "noip-duc";
  };
})
