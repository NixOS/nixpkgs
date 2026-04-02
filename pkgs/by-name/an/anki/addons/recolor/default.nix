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

  patches = [
    # With this patch, Nix users only need to update their ReColor config when a
    # migration happens rather than on every update.
    # Upstream always wants the last used addon version in the config file in case an
    # update corrupts the config. That isn't a concern here, since the config is
    # readonly with Nix.
    ./only-update-config-version-when-migration-happens.patch
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ReColor your Anki desktop to whatever aesthetic you like";
    longDescription = ''
      This add-on must be configured with a theme to use. You can find some pre-made
      themes at <https://github.com/AnKing-VIP/AnkiRecolor/wiki/Themes>.

      Example:

      ```nix
      pkgs.ankiAddons.recolor.withConfig {
        config = {
          colors = {
            ACCENT_CARD = [
              "Card mode"
              "#cba6f7"
              "#cba6f7"
              "--accent-card"
            ];
            # ...
          };
          version = {
            major = 3;
            minor = 1;
          };
        };
      }
      ```
    '';
    homepage = "https://github.com/AnKing-VIP/AnkiRecolor";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ junestepp ];
  };
})
