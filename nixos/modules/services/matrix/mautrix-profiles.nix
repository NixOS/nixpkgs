{ lib, pkgs }:
let
  logging = {
    min_level = "info";
    writers = [
      {
        type = "stdout";
        format = "pretty-colored";
        time_format = " ";
      }
    ];
  };
  bridgev2 = {
    schema = "bridgev2";
    settings = {
      inherit logging;
      double_puppet = {
        servers = { };
        secrets = { };
      };
    };
  };
  meta = mode: port: avatar: {
    inherit (bridgev2) schema;
    package = pkgs.mautrix-meta;
    executable = if mode == "instagram" then "mautrix-instagram" else "mautrix-meta";
    registrationName = "meta";
    secretPrefix = "META";
    memoryDenyWriteExecute = true;
    useAppserviceHostnameForAddress = true;
    assertions = name: bridge: [
      {
        assertion = !(bridge.settings ? bridge.disable_xma);
        message = "services.mautrix.bridges.${name}: 'bridge.disable_xma' has been moved to 'network.disable_xma_always'.";
      }
      {
        assertion = !(bridge.settings ? bridge.displayname_template);
        message = "services.mautrix.bridges.${name}: 'bridge.displayname_template' has been moved to 'network.displayname_template'.";
      }
      {
        assertion = !(bridge.settings ? meta);
        message = "services.mautrix.bridges.${name}: 'meta' has been moved to 'network'.";
      }
    ];
    settings = lib.recursiveUpdate bridgev2.settings {
      network = { inherit mode; };
      bridge.permissions = { };
      homeserver.software = "standard";
      appservice = {
        inherit port;
        hostname = "localhost";
        id = mode;
        bot = {
          username = "${mode}bot";
          displayname = "${if mode == "instagram" then "Instagram" else "Facebook"} bridge bot";
          inherit avatar;
        };
        username_template = "${mode}_{{.}}";
      };
      encryption = {
        allow = true;
        default = true;
        require = true;
        # Retain the legacy migration key: changing it makes existing databases unreadable.
        pickle_key = "mautrix.bridge.e2ee";
        delete_keys = {
          dont_store_outbound = true;
          ratchet_on_decrypt = true;
          delete_fully_used_on_decrypt = true;
          delete_prev_on_new_session = true;
          delete_on_device_delete = true;
          periodically_delete_expired = true;
          delete_outdated_inbound = true;
        };
        verification_levels = {
          receive = "cross-signed-tofu";
          send = "cross-signed-tofu";
          share = "cross-signed-tofu";
        };
      };
    };
  };
in
{
  whatsapp = bridgev2 // {
    package = pkgs.mautrix-whatsapp;
    executable = "mautrix-whatsapp";
    registrationName = "whatsapp";
    settings = lib.recursiveUpdate bridgev2.settings {
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
  };
  signal = bridgev2 // {
    package = pkgs.mautrix-signal;
    executable = "mautrix-signal";
    registrationName = "signal";
    settings = lib.recursiveUpdate bridgev2.settings {
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
  };
  facebook = meta "facebook" 29321 "mxc://maunium.net/ygtkteZsXnGJLJHRchUwYWak";
  instagram = meta "instagram" 29320 "mxc://maunium.net/JxjlbZUlCPULEeHZSwleUXQv";
  discord = {
    schema = "legacy";
    package = pkgs.mautrix-discord;
    executable = "mautrix-discord";
    registrationName = "discord";
    extraPackages = [ pkgs.lottieconverter ];
    settings = {
      inherit logging;
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
  };
  telegram = bridgev2 // {
    package = pkgs.mautrix-telegram;
    executable = "mautrix-telegram";
    registrationName = "telegram";
    extraPackages = [ pkgs.lottieconverter ];
    settings = lib.recursiveUpdate bridgev2.settings {
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
  };
}
