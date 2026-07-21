{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bvi";
  version = "1.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/bvi/bvi-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-ZUBxaho7K5cRY1EI2hSya66kiIgdSmghIcC927prdMs=";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "Hex editor with vim style keybindings";
    homepage = "https://bvi.sourceforge.net/download.html";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
