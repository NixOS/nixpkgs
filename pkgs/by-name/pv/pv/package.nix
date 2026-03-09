{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pv";
  version = "1.10.4";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${finalAttrs.version}.tar.gz";
    hash = "sha256-fplPm4ZFggookohGgFFXWt8JoeaI2OTY+j7MSHeL98k=";
  };

  meta = {
    homepage = "https://www.ivarch.com/programs/pv.shtml";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.all;
    mainProgram = "pv";
  };
})
