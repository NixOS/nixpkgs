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
  name = "telegram";
  description = "Mautrix-Telegram, a Matrix-Telegram hybrid puppeting/relaybot bridge";
  extraPackages = [ pkgs.lottieconverter ];
  defaultSettings = {
    network.displayname_template = "{{ if .Deleted }}Deleted account {{ .UserID }}{{ else }}{{ .FullName }}{{ end }}";
    bridge = {
      command_prefix = "!tg";
      relay.enabled = true;
      permissions."*" = "relay";
    };
    appservice = {
      port = 29317;
      id = "telegram";
      bot = {
        username = "telegrambot";
        displayname = "Telegram Bridge Bot";
      };
      username_template = "telegram_{{.}}";
    };
  };
  settingsDescription = ''
    {file}`config.yaml` configuration as a Nix attribute set.
    Configuration options should match those described in the example configuration.
    Get an example configuration by executing `mautrix-telegram -c example.yaml --generate-example-config`.
    Secret tokens (including MTProto API credentials `network.api_id` and `network.api_hash`)
    should be specified using {option}`environmentFiles` instead of this world-readable
    attribute set (for example via `MAUTRIX_TELEGRAM_NETWORK__API_ID` and
    `MAUTRIX_TELEGRAM_NETWORK__API_HASH`, or via `$VARIABLE` references in `settings`).
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
      network = {
        api_id = "json::$TELEGRAM_API_ID";
        api_hash = "$TELEGRAM_API_HASH";
      };
    }
  '';
  settingsDefaultText = lib.literalMD ''
    Default `sqlite3-fk-wal` database under `dataDir`, appservice listening on
    `127.0.0.1:29317` (`http://127.0.0.1:<port>`), stdout logging, and
    `bridge.permissions."*" = "relay"`.
  '';
  meta = {
    maintainers = with lib.maintainers; [
      euxane
      vskilet
    ];
  };
}
