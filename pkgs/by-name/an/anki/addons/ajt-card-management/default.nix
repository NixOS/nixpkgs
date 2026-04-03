{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:

anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "ajt-card-management";
  version = "25.10.14.0";
  src =
    (fetchFromGitHub {
      owner = "Ajatt-Tools";
      repo = "learn-now-button";
      rev = "v${finalAttrs.version}";
      hash = "sha256-ebGMrEfDV9ZWtrV2AjiaNd7WMeNBHlaOBE2xL1x0nWs=";
      fetchSubmodules = true;
    })
    # HACK: remove when https://github.com/Ajatt-Tools/learn-now-button/pull/9 is released
    .overrideAttrs
      (oldAttrs: {
        env = oldAttrs.env or { } // {
          GIT_CONFIG_COUNT = 1;
          GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
          GIT_CONFIG_VALUE_0 = "git@github.com:";
        };
      });
  sourceRoot = "${finalAttrs.src.name}/card_management";
  passthru.updateScript = nix-update-script { };
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
