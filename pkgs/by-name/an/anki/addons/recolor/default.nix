{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "recolor";
  version = "3.3";
  src = fetchFromGitHub {
    owner = "AnKing-VIP";
    repo = "AnkiRecolor";
    tag = finalAttrs.version;
    sparseCheckout = [ "src/addon" ];
    hash = "sha256-Rfie1m4wfwZvmxxFngt1tky1j5dIZKX7c64A1pSbE3c=";
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
