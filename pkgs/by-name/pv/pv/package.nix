{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pv";
  version = "1.9.15";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${finalAttrs.version}.tar.gz";
    hash = "sha256-4rF1ZKueuh7Cyq4oWWDL82O0QB3/2hkaYKC+/mjhfaw=";
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
