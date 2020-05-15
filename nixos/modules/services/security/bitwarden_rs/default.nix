{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bitwarden_rs;
  user = config.users.users.bitwarden_rs.name;
  group = config.users.groups.bitwarden_rs.name;

  # Convert name from camel case (e.g. disable2FARemember) to upper case snake case (e.g. DISABLE_2FA_REMEMBER).
  nameToEnvVar = name:
    let
      parts = builtins.split "([A-Z0-9]+)" name;
      partsToEnvVar = parts: foldl' (key: x: let last = stringLength key - 1; in
        if isList x then key + optionalString (key != "" && substring last 1 key != "_") "_" + head x
        else if key != "" && elem (substring 0 1 x) lowerChars then # to handle e.g. [ "disable" [ "2FAR" ] "emember" ]
          substring 0 last key + optionalString (substring (last - 1) 1 key != "_") "_" + substring last 1 key + toUpper x
        else key + toUpper x) "" parts;
    in if builtins.match "[A-Z0-9_]+" name != null then name else partsToEnvVar parts;

  # Due to the different naming schemes allowed for config keys,
  # we can only check for values consistently after converting them to their corresponding environment variable name.
  configEnv =
    let
      configEnv = listToAttrs (concatLists (mapAttrsToList (name: value:
        if value != null then [ (nameValuePair (nameToEnvVar name) (if isBool value then boolToString value else toString value)) ] else []
      ) cfg.config));
    in { DATA_FOLDER = "/var/lib/bitwarden_rs"; } // optionalAttrs (!(configEnv ? WEB_VAULT_ENABLED) || configEnv.WEB_VAULT_ENABLED == "true") {
      WEB_VAULT_FOLDER = "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
    } // configEnv;

  configFile = pkgs.writeText "bitwarden_rs.env" (concatStrings (mapAttrsToList (name: value: "${name}=${value}\n") configEnv));

  bitwarden_rs = pkgs.bitwarden_rs.override { inherit (cfg) dbBackend; };

in {
  options.services.bitwarden_rs = with types; {
    enable = mkEnableOption "bitwarden_rs";

    dbBackend = mkOption {
      type = enum [ "sqlite" "mysql" "postgresql" ];
      default = "sqlite";
      description = ''
        Which database backend bitwarden_rs will be using.
      '';
    };

    backupDir = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        The directory under which bitwarden_rs will backup its persistent data.
      '';
    };

    config = mkOption {
      type = attrsOf (nullOr (oneOf [ bool int str ]));
      default = {};
      example = literalExample ''
        {
          domain = "https://bw.domain.tld:8443";
          signupsAllowed = true;
          rocketPort = 8222;
          rocketLog = "critical";
        }
      '';
      description = ''
        The configuration of bitwarden_rs is done through environment variables,
        therefore the names are converted from camel case (e.g. disable2FARemember)
        to upper case snake case (e.g. DISABLE_2FA_REMEMBER).
        In this conversion digits (0-9) are handled just like upper case characters,
        so foo2 would be converted to FOO_2.
        Names already in this format remain unchanged, so FOO2 remains FOO2 if passed as such,
        even though foo2 would have been converted to FOO_2.
        This allows working around any potential future conflicting naming conventions.

        Based on the attributes passed to this config option an environment file will be generated
        that is passed to bitwarden_rs's systemd service.

        The available configuration options can be found in
        <link xlink:href="https://github.com/dani-garcia/bitwarden_rs/blob/${bitwarden_rs.version}/.env.template">the environment template file</link>.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = cfg.backupDir != null -> cfg.dbBackend == "sqlite";
      message = "Backups for database backends other than sqlite will need customization";
    } ];

    users.users.bitwarden_rs = {
      inherit group;
      isSystemUser = true;
    };
    users.groups.bitwarden_rs = { };

    systemd.services.bitwarden_rs = {
      after = [ "network.target" ];
      path = with pkgs; [ openssl ];
      serviceConfig = {
        User = user;
        Group = group;
        EnvironmentFile = configFile;
        ExecStart = "${bitwarden_rs}/bin/bitwarden_rs";
        LimitNOFILE = "1048576";
        LimitNPROC = "64";
        PrivateTmp = "true";
        PrivateDevices = "true";
        ProtectHome = "true";
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        StateDirectory = "bitwarden_rs";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.backup-bitwarden_rs = mkIf (cfg.backupDir != null) {
      description = "Backup bitwarden_rs";
      environment = {
        DATA_FOLDER = "/var/lib/bitwarden_rs";
        BACKUP_FOLDER = cfg.backupDir;
      };
      path = with pkgs; [ sqlite ];
      serviceConfig = {
        SyslogIdentifier = "backup-bitwarden_rs";
        Type = "oneshot";
        User = mkDefault user;
        Group = mkDefault group;
        ExecStart = "${pkgs.bash}/bin/bash ${./backup.sh}";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.timers.backup-bitwarden_rs = mkIf (cfg.backupDir != null) {
      description = "Backup bitwarden_rs on time";
      timerConfig = {
        OnCalendar = mkDefault "23:00";
        Persistent = "true";
        Unit = "backup-bitwarden_rs.service";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
