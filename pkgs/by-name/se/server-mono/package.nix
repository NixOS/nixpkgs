{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "server-mono";
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/internet-development/www-server-mono/releases/download/v${finalAttrs.version}/ServerMono-fonts.zip";
    hash = "sha256-e8dOflWAC8Q8g2q3DiofW+LEpmPduklbj8+vxoumP70=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ installFonts ];
  postPatch = ''
    rm extras/ -rf
  '';

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Monospace typeface inspired by typewriters, SF Mono, ASCII art and command-line tools";
    homepage = "https://servermono.com/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ lks ];
  };
})
