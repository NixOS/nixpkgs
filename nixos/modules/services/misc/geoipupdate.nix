{ config, lib, pkgs, ... }:

let
  cfg = config.services.geoipupdate;
  inherit (builtins) isAttrs isString isInt isList typeOf hashString;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "geoip-updater" ] "services.geoip-updater has been removed, use services.geoipupdate instead.")
  ];

  options = {
    services.geoipupdate = {
      enable = lib.mkEnableOption (lib.mdDoc ''
        periodic downloading of GeoIP databases using geoipupdate.
      '');

      interval = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = lib.mdDoc ''
          Update the GeoIP databases at this time / interval.
          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      settings = lib.mkOption {
        example = lib.literalExpression ''
          {
            AccountID = 200001;
            DatabaseDirectory = "/var/lib/GeoIP";
            LicenseKey = { _secret = "/run/keys/maxmind_license_key"; };
            Proxy = "10.0.0.10:8888";
            ProxyUserPassword = { _secret = "/run/keys/proxy_pass"; };
          }
        '';
        description = lib.mdDoc ''
          geoipupdate configuration options. See
          <https://github.com/maxmind/geoipupdate/blob/main/doc/GeoIP.conf.md>
          for a full list of available options.

          Settings containing secret data should be set to an
          attribute set containing the attribute
          `_secret` - a string pointing to a file
          containing the value the option should be set to. See the
          example to get a better picture of this: in the resulting
          {file}`GeoIP.conf` file, the
          `ProxyUserPassword` key will be set to the
          contents of the
          {file}`/run/keys/proxy_pass` file.
        '';
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            let
              type = oneOf [str int bool];
            in
              attrsOf (either type (listOf type));

          options = {

            AccountID = lib.mkOption {
              type = lib.types.int;
              description = lib.mdDoc ''
                Your MaxMind account ID.
              '';
            };

            EditionIDs = lib.mkOption {
              type = with lib.types; listOf (either str int);
              example = [
                "GeoLite2-ASN"
                "GeoLite2-City"
                "GeoLite2-Country"
              ];
              description = lib.mdDoc ''
                List of database edition IDs. This includes new string
                IDs like `GeoIP2-City` and old
                numeric IDs like `106`.
              '';
            };

            LicenseKey = lib.mkOption {
              type = with lib.types; either path (attrsOf path);
              description = lib.mdDoc ''
                A file containing the MaxMind license key.

                Always handled as a secret whether the value is
                wrapped in a `{ _secret = ...; }`
                attrset or not (refer to [](#opt-services.geoipupdate.settings) for
                details).
              '';
              apply = x: if isAttrs x then x else { _secret = x; };
            };

            DatabaseDirectory = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/GeoIP";
              example = "/run/GeoIP";
              description = lib.mdDoc ''
                The directory to store the database files in. The
                directory will be automatically created, the owner
                changed to `geoip` and permissions
                set to world readable. This applies if the directory
                already exists as well, so don't use a directory with
                sensitive contents.
              '';
            };

          };
        };
      };
    };

  };

  config = lib.mkIf cfg.enable {

    services.geoipupdate.settings = {
      LockFile = "/run/geoipupdate/.lock";
    };

    systemd.services.geoipupdate-create-db-dir = {
      serviceConfig.Type = "oneshot";
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit

        mkdir -p ${cfg.settings.DatabaseDirectory}
        chmod 0755 ${cfg.settings.DatabaseDirectory}
      '';
    };

    systemd.services.geoipupdate = {
      description = "GeoIP Updater";
      requires = [ "geoipupdate-create-db-dir.service" ];
      after = [
        "geoipupdate-create-db-dir.service"
        "network-online.target"
        "nss-lookup.target"
      ];
      path = [ pkgs.replace-secret ];
      wants = [ "network-online.target" ];
      startAt = cfg.interval;
      serviceConfig = {
        ExecStartPre =
          let
            isSecret = v: isAttrs v && v ? _secret && isString v._secret;
            geoipupdateKeyValue = lib.generators.toKeyValue {
              mkKeyValue = lib.flip lib.generators.mkKeyValueDefault " " rec {
                mkValueString = v:
                  if isInt           v then toString v
                  else if isString   v then v
                  else if true  ==   v then "1"
                  else if false ==   v then "0"
                  else if isList     v then lib.concatMapStringsSep " " mkValueString v
                  else if isSecret   v then hashString "sha256" v._secret
                  else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
              };
            };
            secretPaths = lib.catAttrs "_secret" (lib.collect isSecret cfg.settings);
            mkSecretReplacement = file: ''
              replace-secret ${lib.escapeShellArgs [ (hashString "sha256" file) file "/run/geoipupdate/GeoIP.conf" ]}
            '';
            secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;

            geoipupdateConf = pkgs.writeText "geoipupdate.conf" (geoipupdateKeyValue cfg.settings);

            script = ''
              set -o errexit -o pipefail -o nounset -o errtrace
              shopt -s inherit_errexit

              chown geoip "${cfg.settings.DatabaseDirectory}"

              cp ${geoipupdateConf} /run/geoipupdate/GeoIP.conf
              ${secretReplacements}
            '';
          in
            "+${pkgs.writeShellScript "start-pre-full-privileges" script}";
        ExecStart = "${pkgs.geoipupdate}/bin/geoipupdate -f /run/geoipupdate/GeoIP.conf";
        User = "geoip";
        DynamicUser = true;
        ReadWritePaths = cfg.settings.DatabaseDirectory;
        RuntimeDirectory = "geoipupdate";
        RuntimeDirectoryMode = "0700";
        CapabilityBoundingSet = "";
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictRealtime = true;
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
      };
    };

    systemd.timers.geoipupdate-initial-run = {
      wantedBy = [ "timers.target" ];
      unitConfig.ConditionPathExists = "!${cfg.settings.DatabaseDirectory}";
      timerConfig = {
        Unit = "geoipupdate.service";
        OnActiveSec = 0;
      };
    };
  };

  meta.maintainers = [ lib.maintainers.talyz ];
}
