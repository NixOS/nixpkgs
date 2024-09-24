{ config, lib, pkgs, options, ... }:
let
  cfg = config.services.biboumi;
  inherit (config.environment) etc;
  rootDir = "/run/biboumi/mnt-root";
  stateDir = "/var/lib/biboumi";
  settingsFile = pkgs.writeText "biboumi.cfg" (
    lib.generators.toKeyValue {
      mkKeyValue = k: v:
        lib.optionalString (v != null) (lib.generators.mkKeyValueDefault {} "=" k v);
    } cfg.settings);
  need_CAP_NET_BIND_SERVICE = cfg.settings.identd_port != 0 && cfg.settings.identd_port < 1024;
in
{
  options = {
    services.biboumi = {
      enable = lib.mkEnableOption "the Biboumi XMPP gateway to IRC";

      settings = lib.mkOption {
        description = ''
          See [biboumi 8.5](https://lab.louiz.org/louiz/biboumi/blob/8.5/doc/biboumi.1.rst)
          for documentation.
        '';
        default = {};
        type = lib.types.submodule {
          freeformType = with lib.types;
            (attrsOf (nullOr (oneOf [str int bool]))) // {
              description = "settings option";
            };
          options.admin = lib.mkOption {
            type = with lib.types; listOf str;
            default = [];
            example = ["admin@example.org"];
            apply = lib.concatStringsSep ":";
            description = ''
              The bare JID of the gateway administrator. This JID will have more
              privileges than other standard users, for example some administration
              ad-hoc commands will only be available to that JID.
            '';
          };
          options.ca_file = lib.mkOption {
            type = lib.types.path;
            default = "/etc/ssl/certs/ca-certificates.crt";
            description = ''
              Specifies which file should be used as the list of trusted CA
              when negotiating a TLS session.
            '';
          };
          options.db_name = lib.mkOption {
            type = with lib.types; either path str;
            default = "${stateDir}/biboumi.sqlite";
            description = ''
              The name of the database to use.
            '';
            example = "postgresql://user:secret@localhost";
          };
          options.hostname = lib.mkOption {
            type = lib.types.str;
            example = "biboumi.example.org";
            description = ''
              The hostname served by the XMPP gateway.
              This domain must be configured in the XMPP server
              as an external component.
            '';
          };
          options.identd_port = lib.mkOption {
            type = lib.types.port;
            default = 113;
            example = 0;
            description = ''
              The TCP port on which to listen for identd queries.
            '';
          };
          options.log_level = lib.mkOption {
            type = lib.types.ints.between 0 3;
            default = 1;
            description = ''
              Indicate what type of log messages to write in the logs.
              0 is debug, 1 is info, 2 is warning, 3 is error.
            '';
          };
          options.password = lib.mkOption {
            type = with lib.types; nullOr str;
            description = ''
              The password used to authenticate the XMPP component to your XMPP server.
              This password must be configured in the XMPP server,
              associated with the external component on
              [hostname](#opt-services.biboumi.settings.hostname).

              Set it to null and use [credentialsFile](#opt-services.biboumi.credentialsFile)
              if you do not want this password to go into the Nix store.
            '';
          };
          options.persistent_by_default = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether all rooms will be persistent by default:
              the value of the “persistent” option in the global configuration of each
              user will be “true”, but the value of each individual room will still
              default to false. This means that a user just needs to change the global
              “persistent” configuration option to false in order to override this.
            '';
          };
          options.policy_directory = lib.mkOption {
            type = lib.types.path;
            default = "${pkgs.biboumi}/etc/biboumi";
            defaultText = lib.literalExpression ''"''${pkgs.biboumi}/etc/biboumi"'';
            description = ''
              A directory that should contain the policy files,
              used to customize Botan’s behaviour
              when negotiating the TLS connections with the IRC servers.
            '';
          };
          options.port = lib.mkOption {
            type = lib.types.port;
            default = 5347;
            description = ''
              The TCP port to use to connect to the local XMPP component.
            '';
          };
          options.realname_customization = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Whether the users will be able to use
              the ad-hoc commands that lets them configure
              their realname and username.
            '';
          };
          options.realname_from_jid = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether the realname and username of each biboumi
              user will be extracted from their JID.
              Otherwise they will be set to the nick
              they used to connect to the IRC server.
            '';
          };
          options.xmpp_server_ip = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = ''
              The IP address to connect to the XMPP server on.
              The connection to the XMPP server is unencrypted,
              so the biboumi instance and the server should
              normally be on the same host.
            '';
          };
        };
      };

      credentialsFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to a configuration file to be merged with the settings.
          Beware not to surround "=" with spaces when setting biboumi's options in this file.
          Useful to merge a file which is better kept out of the Nix store
          because it contains sensible data like
          [password](#opt-services.biboumi.settings.password).
        '';
        default = "/dev/null";
        example = "/run/keys/biboumi.cfg";
      };

      openFirewall = lib.mkEnableOption "opening of the identd port in the firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf (cfg.openFirewall && cfg.settings.identd_port != 0)
      { allowedTCPPorts = [ cfg.settings.identd_port ]; };

    systemd.services.biboumi = {
      description = "Biboumi, XMPP to IRC gateway";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        # Biboumi supports systemd's watchdog.
        WatchdogSec = 20;
        Restart = "always";
        # Use "+" because credentialsFile may not be accessible to User= or Group=.
        ExecStartPre = [("+" + pkgs.writeShellScript "biboumi-prestart" ''
          set -eux
          cat ${settingsFile} '${cfg.credentialsFile}' |
          install -m 644 /dev/stdin /run/biboumi/biboumi.cfg
        '')];
        ExecStart = "${pkgs.biboumi}/bin/biboumi /run/biboumi/biboumi.cfg";
        ExecReload = "${pkgs.coreutils}/bin/kill -USR1 $MAINPID";
        # Firewalls needing opening for output connections can still do that
        # selectively for biboumi with:
        # users.users.biboumi.isSystemUser = true;
        # and, for example:
        # networking.nftables.ruleset = ''
        #   add rule inet filter output meta skuid biboumi tcp accept
        # '';
        DynamicUser = true;
        RootDirectory = rootDir;
        RootDirectoryStartOnly = true;
        InaccessiblePaths = [ "-+${rootDir}" ];
        RuntimeDirectory = [ "biboumi" (lib.removePrefix "/run/" rootDir) ];
        RuntimeDirectoryMode = "700";
        StateDirectory = "biboumi";
        StateDirectoryMode = "700";
        MountAPIVFS = true;
        UMask = "0066";
        BindPaths = [
          stateDir
          # This is for Type="notify"
          # See https://github.com/systemd/systemd/issues/3544
          "/run/systemd/notify"
          "/run/systemd/journal/socket"
        ];
        BindReadOnlyPaths = [
          builtins.storeDir
          "/etc"
        ];
        # The following options are only for optimizing:
        # systemd-analyze security biboumi
        AmbientCapabilities = [ (lib.optionalString need_CAP_NET_BIND_SERVICE "CAP_NET_BIND_SERVICE") ];
        CapabilityBoundingSet = [ (lib.optionalString need_CAP_NET_BIND_SERVICE "CAP_NET_BIND_SERVICE") ];
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = lib.mkDefault false;
        PrivateTmp = true;
        # PrivateUsers=true breaks AmbientCapabilities=CAP_NET_BIND_SERVICE
        # See https://bugs.archlinux.org/task/65921
        PrivateUsers = !need_CAP_NET_BIND_SERVICE;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        # AF_UNIX is for /run/systemd/notify
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallFilter = [
          "@system-service"
          # Groups in @system-service which do not contain a syscall
          # listed by perf stat -e 'syscalls:sys_enter_*' biboumi biboumi.cfg
          # in tests, and seem likely not necessary for biboumi.
          # To run such a perf in ExecStart=, you have to:
          # - AmbientCapabilities="CAP_SYS_ADMIN"
          # - mount -o remount,mode=755 /sys/kernel/debug/{,tracing}
          "~@aio" "~@chown" "~@ipc" "~@keyring" "~@resources" "~@setuid" "~@timer"
        ];
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ julm ];
}
