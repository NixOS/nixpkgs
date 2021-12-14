{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.teleirc;

  format = pkgs.formats.keyValue {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString = v:
        # We quote string values, or channel names will be interpreted as comments
        if builtins.isString v
        then "\"" + strings.escape ["\""] v + "\""
        else generators.mkValueStringDefault {} v;
    } "=";
  };

  bridgeOpts = { ... }: {
    options = {
      settings = mkOption {
        type = format.type;
        description = ''
          Configuration for TeleIRC. See
          <link xlink:href="https://docs.teleirc.com/en/latest/user/config-file-glossary/" /> and
          <link xlink:href="https://github.com/RITlug/teleirc/blob/main/env.example" />.
          Prefer using <option>secretsFile</option> for IRC passwords and Telegram/Imgur tokens.
        '';
        example = literalExpression ''
          {
            IRC_SERVER = "irc.libera.chat";
            IRC_PORT = 6697;

            IRC_USE_SSL = true;
            IRC_CERT_ALLOW_EXPIRED = false;
            IRC_CERT_ALLOW_SELFSIGNED = false;

            IRC_CHANNEL = "#nixos";

            IRC_BOT_NAME = "my-teleirc-bridge";
            IRC_BOT_IDENT = "teleirc";

            TELEGRAM_CHAT_ID = -1000000000000;
          }
        '';
      };
      secretsFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Path to a file containing secret configuration values in systemd
          environment file format.
          Example contents of the file:
          <literallayout>
          IRC_SERVER_PASSWORD="hunter2";
          TELEIRC_TOKEN="0000000000:AAAAAAA-AAAAAAAAAAAAAAAAAAAAAAAAAAA";
          IMGUR_CLIENT_ID="000000000000000";
          </literallayout>
        '';
      };
    };
  };

  generateUnit = name: values: nameValuePair "teleirc-${name}" {
    description = "TeleIRC IRC-Telegram bridge - ${name}";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.teleirc}/bin/cmd -conf '${format.generate "teleirc-${name}.env" values.settings}'";
      User = "teleirc";
      Restart = "always"; # https://github.com/RITlug/teleirc/issues/359
      # Hardening
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
      UMask = "0077";
    } // optionalAttrs (values.secretsFile != null) {
      EnvironmentFile = values.secretsFile;
    };
  };

in {
  # Interface
  options.services.teleirc = {
    bridges = mkOption {
      description = "TeleIRC bridges";
      default = {};
      type = with types; attrsOf (submodule bridgeOpts);
    };
  };

  # Implementation
  config = mkIf (cfg.bridges != {}) {
    users.users.teleirc = {
      description = "TeleIRC service user";
      isSystemUser = true;
      group = "teleirc";
    };
    users.groups.teleirc = {};
    systemd.services = mapAttrs' generateUnit cfg.bridges;
  };

  meta.maintainers = with lib.maintainers; [ fgaz ];
}
