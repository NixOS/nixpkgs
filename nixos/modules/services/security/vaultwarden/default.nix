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
      configEnv = concatMapAttrs (name: value: optionalAttrs (value != null) {
        ${nameToEnvVar name} = if isBool value then boolToString value else toString value;
      }) cfg.config;
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
    enable = mkEnableOption (lib.mdDoc "vaultwarden");

    dbBackend = mkOption {
      type = enum [ "sqlite" "mysql" "postgresql" ];
      default = "sqlite";
      description = lib.mdDoc ''
        Which database backend vaultwarden will be using.
      '';
    };

    backupDir = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc ''
        The directory under which vaultwarden will backup its persistent data.
      '';
    };

    config = mkOption {
      type = attrsOf (nullOr (oneOf [ bool int str ]));
      default = {
        ROCKET_ADDRESS = "::1"; # default to localhost
        ROCKET_PORT = 8222;
      };
      example = literalExpression ''
        {
          DOMAIN = "https://bitwarden.example.com";
          SIGNUPS_ALLOWED = false;

          # Vaultwarden currently recommends running behind a reverse proxy
          # (nginx or similar) for TLS termination, see
          # https://github.com/dani-garcia/vaultwarden/wiki/Hardening-Guide#reverse-proxying
          # > you should avoid enabling HTTPS via vaultwarden's built-in Rocket TLS support,
          # > especially if your instance is publicly accessible.
          #
          # A suitable NixOS nginx reverse proxy example config might be:
          #
          #     services.nginx.virtualHosts."bitwarden.example.com" = {
          #       enableACME = true;
          #       forceSSL = true;
          #       locations."/" = {
          #         proxyPass = "http://127.0.0.1:''${toString config.services.vaultwarden.config.ROCKET_PORT}";
          #       };
          #     };
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;

          ROCKET_LOG = "critical";

          # This example assumes a mailserver running on localhost,
          # thus without transport encryption.
          # If you use an external mail server, follow:
          #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
          SMTP_HOST = "127.0.0.1";
          SMTP_PORT = 25;
          SMTP_SSL = false;

          SMTP_FROM = "admin@bitwarden.example.com";
          SMTP_FROM_NAME = "example.com Bitwarden server";
        }
      '';
      description = lib.mdDoc ''
        The configuration of vaultwarden is done through environment variables,
        therefore it is recommended to use upper snake case (e.g. {env}`DISABLE_2FA_REMEMBER`).

        However, camel case (e.g. `disable2FARemember`) is also supported:
        The NixOS module will convert it automatically to
        upper case snake case (e.g. {env}`DISABLE_2FA_REMEMBER`).
        In this conversion digits (0-9) are handled just like upper case characters,
        so `foo2` would be converted to {env}`FOO_2`.
        Names already in this format remain unchanged, so `FOO2` remains `FOO2` if passed as such,
        even though `foo2` would have been converted to {env}`FOO_2`.
        This allows working around any potential future conflicting naming conventions.

        Based on the attributes passed to this config option an environment file will be generated
        that is passed to vaultwarden's systemd service.

        The available configuration options can be found in
        [the environment template file](https://github.com/dani-garcia/vaultwarden/blob/${vaultwarden.version}/.env.template).

        See [](#opt-services.vaultwarden.environmentFile) for how
        to set up access to the Admin UI to invite initial users.
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/var/lib/vaultwarden.env";
      description = lib.mdDoc ''
        Additional environment file as defined in {manpage}`systemd.exec(5)`.

        Secrets like {env}`ADMIN_TOKEN` and {env}`SMTP_PASSWORD`
        may be passed to the service without adding them to the world-readable Nix store.

        Note that this file needs to be available on the host on which
        `vaultwarden` is running.

        As a concrete example, to make the Admin UI available
        (from which new users can be invited initially),
        the secret {env}`ADMIN_TOKEN` needs to be defined as described
        [here](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page).
        Setting `environmentFile` to `/var/lib/vaultwarden.env`
        and ensuring permissions with e.g.
        `chown vaultwarden:vaultwarden /var/lib/vaultwarden.env`
        (the `vaultwarden` user will only exist after activating with
        `enable = true;` before this), we can set the contents of the file to have
        contents such as:

        ```
        # Admin secret token, see
        # https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page
        ADMIN_TOKEN=...copy-paste a unique generated secret token here...
        ```
      '';
    };

    package = mkOption {
      type = package;
      default = pkgs.vaultwarden;
      defaultText = literalExpression "pkgs.vaultwarden";
      description = lib.mdDoc "Vaultwarden package to use.";
    };

    webVaultPackage = mkOption {
      type = package;
      default = pkgs.vaultwarden.webvault;
      defaultText = literalExpression "pkgs.vaultwarden.webvault";
      description = lib.mdDoc "Web vault package to use.";
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
        StateDirectoryMode = "0700";
        Restart = "always";
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
      # if both services are started at the same time, vaultwarden fails with "database is locked"
      before = [ "vaultwarden.service" ];
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
      aliases = [ "backup-bitwarden_rs.timer" ];
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
