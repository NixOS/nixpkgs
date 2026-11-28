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
  name = "signal";
  description = "Mautrix-Signal, a Matrix-Signal puppeting bridge";
  defaultSettings = {
    network.displayname_template = "{{or .ProfileName .PhoneNumber \"Unknown user\"}}";
    bridge = {
      command_prefix = "!signal";
      relay.enabled = true;
      permissions."*" = "relay";
    };
    appservice = {
      hostname = "[::]";
      port = 29328;
      id = "signal";
      bot = {
        username = "signalbot";
        displayname = "Signal Bridge Bot";
      };
      username_template = "signal_{{.}}";
    };
  };
  settingsDescription = ''
    {file}`config.yaml` configuration as a Nix attribute set.
    Configuration options should match those described in the example configuration.
    Get an example configuration by executing `mautrix-signal -c example.yaml --generate-example-config`.
    Secret tokens should be specified using {option}`environmentFiles`
    instead of this world-readable attribute set.
  '';
  settingsExample = lib.literalExpression ''
    {
      bridge = {
        private_chat_portal_meta = true;
        mute_only_on_create = false;
        permissions = {
          "example.com" = "user";
        };
      };
      database = {
        type = "postgres";
        uri = "postgresql:///mautrix-signal?host=/run/postgresql";
      };
      homeserver = {
        address = "http://[::1]:8008";
        domain = "my-domain.tld";
      };
      appservice = {
        id = "signal";
        ephemeral_events = false;
      };
      matrix.message_status_events = true;
      provisioning.shared_secret = "disable";
      backfill.enabled = true;
      encryption = {
        allow = true;
        default = true;
        require = true;
        pickle_key = "$ENCRYPTION_PICKLE_KEY";
      };
    }
  '';
  settingsDefaultText = lib.literalMD ''
    Default `sqlite3-fk-wal` database under `dataDir`, appservice listening on
    `[::]:29328` (`http://127.0.0.1:<port>`), stdout logging, and
    `bridge.permissions."*" = "relay"`.
  '';
  meta = {
    doc = ./signal.md;
    maintainers = with lib.maintainers; [
      pentane
      frederictobiasc
    ];
  };
}
