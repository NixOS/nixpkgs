{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {

  pname = "mononoki";
  version = "1.6";

  src = fetchzip {
    url = "https://github.com/madmalik/mononoki/releases/download/${finalAttrs.version}/mononoki.zip";
    stripRoot = false;
    hash = "sha256-HQM9rzIJXLOScPEXZu0MzRlblLfbVVNJ+YvpONxXuwQ=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    homepage = "https://github.com/madmalik/mononoki";
    description = "Font for programming and code review";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
