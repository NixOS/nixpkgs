{
  config,
  lib,
  pkgs,
  ...
}:
let
  common = import ./common.nix { inherit lib pkgs; };
in
common.mkBridge {
  nixosConfig = config;
  name = "discord";
  schema = "legacy";
  description = "Mautrix-Discord, a Matrix-Discord puppeting/relaybot bridge";
  extraPackages = [ pkgs.lottieconverter ];
  defaultSettings = {
    appservice = {
      hostname = "0.0.0.0";
      port = 29334;
      id = "discord";
      database.type = "sqlite3";
      bot = {
        username = "discordbot";
        displayname = "Discord bridge bot";
        avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
      };
    };
    bridge.permissions."*" = "relay";
  };
  settingsDescription = ''
    {file}`config.yaml` configuration as a Nix attribute set.

    Configuration options should match those described in
    [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).

    Secret tokens should be specified using {option}`environmentFiles`
    instead of this world-readable attribute set.
  '';
  settingsExample = lib.literalExpression ''
    {
      homeserver = {
        address = "http://localhost:8008";
        domain = "example.com";
      };

      bridge.permissions = {
        "example.com" = "user";
        "@admin:example.com" = "admin";
      };
    }
  '';
  settingsDefaultText = lib.literalMD ''
    Default SQLite database under `dataDir`, appservice listening on
    `0.0.0.0:29334` (`http://127.0.0.1:<port>`), stdout logging, and
    `bridge.permissions."*" = "relay"`.
  '';
  meta = {
    doc = ./discord.md;
    maintainers = with lib.maintainers; [
      mistyttm
    ];
  };
}
