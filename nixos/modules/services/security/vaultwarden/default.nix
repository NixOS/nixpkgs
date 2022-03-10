{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.vaultwarden;
  user = config.users.users.vaultwarden.name;
  group = config.users.groups.vaultwarden.name;

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
      WEB_VAULT_FOLDER = "${cfg.webVaultPackage}/share/vaultwarden/vault";
    } // configEnv;

  configFile = pkgs.writeText "vaultwarden.env" (concatStrings (mapAttrsToList (name: value: "${name}=${value}\n") configEnv));

  vaultwarden = cfg.package.override { inherit (cfg) dbBackend; };

in {
  imports = [
    (mkRenamedOptionModule [ "services" "bitwarden_rs" ] [ "services" "vaultwarden" ])
  ];

  options.services.vaultwarden = with types; {
    enable = mkEnableOption "vaultwarden";

    dbBackend = mkOption {
      type = enum [ "sqlite" "mysql" "postgresql" ];
      default = "sqlite";
      description = ''
        Which database backend vaultwarden will be using.
      '';
    };

    backupDir = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        The directory under which vaultwarden will backup its persistent data.
      '';
    };

    config = mkOption {
      type = attrsOf (nullOr (oneOf [ bool int str ]));
      default = {};
      example = literalExpression ''
        {
          domain = "https://bw.domain.tld:8443";
          signupsAllowed = true;
          rocketPort = 8222;
          rocketLog = "critical";
        }
      '';
      description = ''
        The configuration of vaultwarden is done through environment variables,
        therefore the names are converted from camel case (e.g. disable2FARemember)
        to upper case snake case (e.g. DISABLE_2FA_REMEMBER).
        In this conversion digits (0-9) are handled just like upper case characters,
        so foo2 would be converted to FOO_2.
        Names already in this format remain unchanged, so FOO2 remains FOO2 if passed as such,
        even though foo2 would have been converted to FOO_2.
        This allows working around any potential future conflicting naming conventions.

        Based on the attributes passed to this config option an environment file will be generated
        that is passed to vaultwarden's systemd service.

        The available configuration options can be found in
        <link xlink:href="https://github.com/dani-garcia/vaultwarden/blob/${vaultwarden.version}/.env.template">the environment template file</link>.
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/root/vaultwarden.env";
      description = ''
        Additional environment file as defined in <citerefentry>
        <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
        </citerefentry>.

        Secrets like <envar>ADMIN_TOKEN</envar> and <envar>SMTP_PASSWORD</envar>
        may be passed to the service without adding them to the world-readable Nix store.

        Note that this file needs to be available on the host on which
        <literal>vaultwarden</literal> is running.
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.vaultwarden;
      defaultText = literalExpression "pkgs.vaultwarden";
      description = "Vaultwarden package to use.";
    };

    webVaultPackage = mkOption {
      type = package;
      default = pkgs.vaultwarden-vault;
      defaultText = literalExpression "pkgs.vaultwarden-vault";
      description = "Web vault package to use.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = cfg.backupDir != null -> cfg.dbBackend == "sqlite";
      message = "Backups for database backends other than sqlite will need customization";
    } ];

    users.users.vaultwarden = {
      inherit group;
      isSystemUser = true;
    };
    users.groups.vaultwarden = { };

    systemd.services.vaultwarden = {
      aliases = [ "bitwarden_rs.service" ];
      after = [ "network.target" ];
      path = with pkgs; [ openssl ];
      serviceConfig = {
        User = user;
        Group = group;
        EnvironmentFile = [ configFile ] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${vaultwarden}/bin/vaultwarden";
        LimitNOFILE = "1048576";
        PrivateTmp = "true";
        PrivateDevices = "true";
        ProtectHome = "true";
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        StateDirectory = "bitwarden_rs";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.backup-vaultwarden = mkIf (cfg.backupDir != null) {
      aliases = [ "backup-bitwarden_rs.service" ];
      description = "Backup vaultwarden";
      environment = {
        DATA_FOLDER = "/var/lib/bitwarden_rs";
        BACKUP_FOLDER = cfg.backupDir;
      };
      path = with pkgs; [ sqlite ];
      serviceConfig = {
        SyslogIdentifier = "backup-vaultwarden";
        Type = "oneshot";
        User = mkDefault user;
        Group = mkDefault group;
        ExecStart = "${pkgs.bash}/bin/bash ${./backup.sh}";
      };
      wantedBy = [ "multi-user.target" ];
    };

    systemd.timers.backup-vaultwarden = mkIf (cfg.backupDir != null) {
      aliases = [ "backup-bitwarden_rs.service" ];
      description = "Backup vaultwarden on time";
      timerConfig = {
        OnCalendar = mkDefault "23:00";
        Persistent = "true";
        Unit = "backup-vaultwarden.service";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
