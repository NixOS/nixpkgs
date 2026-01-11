{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "recolor";
  version = "3.1";
  src = fetchFromGitHub {
    owner = "AnKing-VIP";
    repo = "AnkiRecolor";
    tag = finalAttrs.version;
    sparseCheckout = [ "src/addon" ];
    hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/addon";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "ReColor your Anki desktop to whatever aesthetic you like";
    homepage = "https://github.com/AnKing-VIP/AnkiRecolor";
    # No license file, but it can be assumed to be AGPL3 based on
    # https://ankiweb.net/account/terms.
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
