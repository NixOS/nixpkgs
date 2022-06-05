{ config, lib, pkgs, ... }:

let
  cfg = config.services.geoipupdate;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "geoip-updater" ] "services.geoip-updater has been removed, use services.geoipupdate instead.")
  ];

  options = {
    services.geoipupdate = {
      enable = lib.mkEnableOption ''
        periodic downloading of GeoIP databases using
        <productname>geoipupdate</productname>.
      '';

      interval = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = ''
          Update the GeoIP databases at this time / interval.
          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      settings = lib.mkOption {
        description = ''
          <productname>geoipupdate</productname> configuration
          options. See
          <link xlink:href="https://github.com/maxmind/geoipupdate/blob/main/doc/GeoIP.conf.md" />
          for a full list of available options.
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
              description = ''
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
              description = ''
                List of database edition IDs. This includes new string
                IDs like <literal>GeoIP2-City</literal> and old
                numeric IDs like <literal>106</literal>.
              '';
            };

            LicenseKey = lib.mkOption {
              type = lib.types.path;
              description = ''
                A file containing the <productname>MaxMind</productname>
                license key.
              '';
            };

            DatabaseDirectory = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/GeoIP";
              example = "/run/GeoIP";
              description = ''
                The directory to store the database files in. The
                directory will be automatically created, the owner
                changed to <literal>geoip</literal> and permissions
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
      wants = [ "network-online.target" ];
      startAt = cfg.interval;
      serviceConfig = {
        ExecStartPre =
          let
            geoipupdateKeyValue = lib.generators.toKeyValue {
              mkKeyValue = lib.flip lib.generators.mkKeyValueDefault " " rec {
                mkValueString = v: with builtins;
                  if isInt           v then toString v
                  else if isString   v then v
                  else if true  ==   v then "1"
                  else if false ==   v then "0"
                  else if isList     v then lib.concatMapStringsSep " " mkValueString v
                  else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
              };
            };

            geoipupdateConf = pkgs.writeText "geoipupdate.conf" (geoipupdateKeyValue cfg.settings);

            script = ''
              chown geoip "${cfg.settings.DatabaseDirectory}"

              cp ${geoipupdateConf} /run/geoipupdate/GeoIP.conf
              ${pkgs.replace-secret}/bin/replace-secret '${cfg.settings.LicenseKey}' \
                                                        '${cfg.settings.LicenseKey}' \
                                                        /run/geoipupdate/GeoIP.conf
            '';
          in
            "+${pkgs.writeShellScript "start-pre-full-privileges" script}";
        ExecStart = "${pkgs.geoipupdate}/bin/geoipupdate -f /run/geoipupdate/GeoIP.conf";
        User = "geoip";
        DynamicUser = true;
        ReadWritePaths = cfg.settings.DatabaseDirectory;
        RuntimeDirectory = "geoipupdate";
        RuntimeDirectoryMode = 0700;
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
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
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
