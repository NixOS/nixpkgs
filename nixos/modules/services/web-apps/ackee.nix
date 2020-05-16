{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ackee;
  defaultSettings = {
    ACKEE_MONGODB = "mongodb://localhost:27017/ackee";
    ACKEE_USERNAME = "ackee";
    ACKEE_PORT = "3000";
    NODE_ENV = "production";
    HOME = "%S/ackee";
  };
in
{
  options.services.ackee = {
    enable = mkEnableOption "the Ackee analytics tool";

    settings = mkOption {
      type = with types; attrsOf (oneOf [ str path package ]);
      default = defaultSettings;
      example = literalExample ''
        {
          ACKEE_MONGODB = "mongodb://localhost:27017/ackee";
          ACKEE_USERNAME = "ackee";
          ACKEE_PORT = "3000";
        }
      '';
      description = ''
        The configuration of Ackee is done through environment variables. The variables defined in
        this settings will be set on the systemd service.

        The available options can be found in
        <link xlink:href="https://github.com/electerious/Ackee/blob/v${pkgs.ackee.version}/docs/Options.md">the documentation</link>.
      '';
    };

    environmentFile = mkOption {
      type = types.path;
      example = "/etc/ackee/credentials";
      description = ''
        Environment file as defined in <citerefentry>
        <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
        </citerefentry>.

        This file should be owned by root and not be readable by anyone but root.
        The file complements the <option>settings</option> option and is supposed to contain
        confidential settings like <literal>ACKEE_PASSWORD</literal>.

        <programlisting>
          # content of the environment file
          ACKEE_PASSWORD=verysecretpassword
        </programlisting>
      '';
    };
  };

  config = mkIf cfg.enable {
    # Warn on outdated mongodb
    warnings = mkIf
      (cfg.settings.ACKEE_MONGODB == defaultSettings.ACKEE_MONGODB
        && config.services.mongodb.enable
        && versionOlder config.services.mongodb.package.version "4.0.6") [
      "Ackee needs at least mongodb 4.0.6"
    ];

    services.mongodb = mkIf (cfg.settings.ACKEE_MONGODB == defaultSettings.ACKEE_MONGODB) {
      enable = mkDefault true;
      package = mkDefault pkgs.mongodb-4_2;
    };

    # Default config
    services.ackee.settings = mapAttrs (_: mkDefault) defaultSettings;

    systemd.services.ackee = {
      description = "Ackee Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" "mongodb.service" ];
      environment = cfg.settings;

      serviceConfig = {
        WorkingDirectory = "%S/ackee";
        StateDirectory = "ackee";
        StateDirectoryMode = "0700";
        ExecStart = "${pkgs.ackee}/bin/ackee";
        EnvironmentFile = cfg.environmentFile;

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ];
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        DynamicUser = true;
        LockPersonality = true;
        # node.js needs this
        #MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        # Port needs to be exposed to the host network
        #PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        # Would re-mount paths ignored by temporary root
        #ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged @resources @setuid @keyring" ];
        TemporaryFileSystem = "/:ro";
        # Does not work well with the temporary root
        #UMask = "0066";
      };
    };
  };
}
