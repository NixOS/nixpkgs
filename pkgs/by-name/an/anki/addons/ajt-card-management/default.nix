{
  lib,
  anki-utils,
  fetchFromGitHub,
}:

anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "ajt-card-management";
  version = "26.10.31.0";
  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "learn-now-button";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MIGlymYle3GEMYMnBhdSHDu50RgI1meJBaIN/rIhmZw=";
    fetchSubmodules = true;
  };
  sourceRoot = "${finalAttrs.src.name}/card_management";
  meta = {
    description = "Reset, Learn, and Grade cards from the card browser";
    longDescription = ''
      Reset, Learn, and Grade cards from the card browser

      This addon adds new buttons to the card browser.
      - The Learn now button immediately puts selected new cards in the learning queue.
      - The Grade now button lets you grade selected cards without opening Reviewer.
      - The Reset selected cards button lets you delete scheduling and learning information from selected cards.
    '';
    homepage = "https://github.com/Ajatt-Tools/learn-now-button";
    downloadPage = "https://ankiweb.net/shared/info/1021636467";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ hey2022 ];
  };
})
