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
  name = "whatsapp";
  description = "Mautrix-WhatsApp, a Matrix-WhatsApp puppeting bridge";
  defaultSettings = {
    network = {
      displayname_template = "{{or .BusinessName .PushName .Phone}} (WA)";
      identity_change_notices = true;
      history_sync.request_full_sync = true;
    };
    bridge = {
      command_prefix = "!wa";
      relay.enabled = true;
      permissions."*" = "relay";
    };
    appservice = {
      hostname = "[::]";
      port = 29318;
      id = "whatsapp";
      bot = {
        username = "whatsappbot";
        displayname = "WhatsApp Bridge Bot";
      };
      username_template = "whatsapp_{{.}}";
    };
  };
  settingsDescription = ''
    {file}`config.yaml` configuration as a Nix attribute set.
    Configuration options should match those described in the example configuration.
    Get an example configuration by executing `mautrix-whatsapp -c example.yaml --generate-example-config`.
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
        uri = "postgresql:///mautrix-whatsapp?host=/run/postgresql";
      };
      homeserver = {
        address = "http://[::1]:8008";
        domain = "my-domain.tld";
      };
      appservice = {
        id = "whatsapp";
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
    `[::]:29318` (`http://127.0.0.1:<port>`), stdout logging, and
    `bridge.permissions."*" = "relay"`.
  '';
  meta = {
    doc = ./whatsapp.md;
    maintainers = with lib.maintainers; [
      pentane
      frederictobiasc
    ];
  };
}
