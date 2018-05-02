{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tuntox.server;
  hostsWhitelistFile = pkgs.writeText "tuntox-hosts-whitelist" ''
    ${toString cfg.hostsWhitelist}
  '';
  persistentIdDirectory = "/var/lib/tuntox";
in
{
  options = {
    services.tuntox.server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, start the Tuntox Service.";
      };

      relayPort = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = "Set TCP relay port (0 disables TCP relaying)";
      };

      portRange = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = "Set Tox UDP port range (<literal>port:port</literal>)";
      };

      persistentId = mkOption {
        type = types.bool;
        default = false;
        description = "If enabled, persist the tox id between runs";
      };

      hostsWhitelist = mkOption {
        type = types.listOf (types.separatedString "\n");
        default = [];
        description = "Only allow connections to the specified <literal>hostname:port</literal> pairs";
      };

      idWhitelist = mkOption {
        type = types.listOf (types.separatedString " ");
        default = [];
        description = "Whitelisted Tox IDs. If empty, id whitelisting will be disabled";
      };

      secret = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shared secret used for connection authentication";
      };
    };
  };

  config = mkIf cfg.enable {

    warnings =
      if cfg.secret == null && cfg.idWhitelist == []
      then [ ''Tuntox is insecure without either <literal>secret</literal>
               or <literal>idWhitelist</literal> non-empty (preferably both).'' ]
      else [];

    users.extraUsers.tuntox = {
      description     = "Tuntox Service user";
      createHome      = false;
      isSystemUser    = true;
      uid             = config.ids.uids.tuntox;
    };

    systemd.services.tuntox = {
      description = "Tuntox Tunnel Service";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target "];

      serviceConfig = {
        Type      = "simple";
        Restart   = "on-failure";
        User      = "tuntox";
        Group     = "tuntox";
        ExecStart =
          ''
            ${pkgs.tuntox}/bin/tuntox \
              -C /var/lib/tuntox \
              ${optionalString (cfg.relayPort != null) "-t ${cfg.relayPort}"} \
              ${optionalString (cfg.portRange != null) "-u ${cfg.portRange}"} \
              ${optionalString (cfg.hostsWhitelist != []) "-f ${hostsWhitelistFile}"} \
              ${toString (map (toxId: "-i ${toxId}") cfg.idWhitelist)}
          '';
        PermissionsStartOnly = true;
        ProtectSystem = "strict";
      } // optionalAttrs cfg.persistentId {
        ReadWriteDirectories = persistentIdDirectory;
      } // optionalAttrs (cfg.secret != null) {
        Environment = "TUNTOX_SHARED_SECRET=${cfg.secret}";
      };

      preStart = ''
        mkdir -p ${persistentIdDirectory}
        chown -R tuntox ${persistentIdDirectory}
        chmod -R ${if cfg.persistentId then "700" else "000"} ${persistentIdDirectory}
      '';
    };
  };
}
