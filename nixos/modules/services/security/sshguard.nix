{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sshguard;
in
{
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  options = {
    services.sshguard = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the sshguard service.";
      };

      attack_threshold = lib.mkOption {
        default = 30;
        type = lib.types.int;
        description = ''
          Block attackers when their cumulative attack score exceeds threshold. Most attacks have a score of 10.
        '';
      };

      blacklist_threshold = lib.mkOption {
        default = null;
        example = 120;
        type = lib.types.nullOr lib.types.int;
        description = ''
          Blacklist an attacker when its score exceeds threshold. Blacklisted addresses are loaded from and added to blacklist-file.
        '';
      };

      blacklist_file = lib.mkOption {
        default = "/var/lib/sshguard/blacklist.db";
        type = lib.types.path;
        description = ''
          Blacklist an attacker when its score exceeds threshold. Blacklisted addresses are loaded from and added to blacklist-file.
        '';
      };

      blocktime = lib.mkOption {
        default = 120;
        type = lib.types.int;
        description = ''
          Block attackers for initially blocktime seconds after exceeding threshold. Subsequent blocks increase by a factor of 1.5.

          sshguard unblocks attacks at random intervals, so actual block times will be longer.
        '';
      };

      detection_time = lib.mkOption {
        default = 1800;
        type = lib.types.int;
        description = ''
          Remember potential attackers for up to detection_time seconds before resetting their score.
        '';
      };

      whitelist = lib.mkOption {
        default = [ ];
        example = [
          "198.51.100.56"
          "198.51.100.2"
        ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Whitelist a list of addresses, hostnames, or address blocks.
        '';
      };

      services = lib.mkOption {
        default = [
          (
            if config.services.openssh.startWhenNeeded then
              {
                name = "sshd-session";
                type = "syslog-id";
              }
            else
              {
                name = "sshd.service";
                type = "service-name";
              }
          )
        ];
        defaultText = lib.literalExpression ''
          [
            (
              if config.services.openssh.startWhenNeeded then
                {
                  name = "sshd-session";
                  type = "syslog-id";
                }
              else
                {
                  name = "sshd.service";
                  type = "service-name";
                }
            )
          ]
        '';
        example = lib.literalExpression ''
          [
            (
              if config.services.openssh.startWhenNeeded then
                {
                  name = "sshd-session";
                  type = "syslog-id";
                }
              else
                {
                  name = "sshd.service";
                  type = "service-name";
                }
            )
            {
              name = "exim.service";
              type = "service-name";
            }
          ]
        '';
        type =
          let
            logTarget = lib.types.submodule {
              options = {
                name = lib.mkOption {
                  description = "Syslog identifier or service unit pattern to include as a log target";
                  type = lib.types.str;
                  example = "sshd@*.service";
                };
                type = lib.mkOption {
                  description = "Whether the log target is a syslog id or a servic unit pattern";
                  type = lib.types.enum [
                    "service-name"
                    "syslog-id"
                  ];
                };
              };
            };

            coerce = name: {
              type = "service";
              inherit name;
            };
          in
          with lib.types;
          listOf (coercedTo str coerce logTarget);
        description = ''
          Systemd services or syslog identifiers sshguard should receive logs of.

          See also <https://github.com/SSHGuard/sshguard/blob/master/src/common/attack.h> for a list of known services.
        '';
      };

      enableInspectableLogStream = lib.mkEnableOption "" // {
        description = ''
          Whether to let `sshguard-logger.service` print the logs sent to `sshguard.service` to its journal.

          This is useful for debugging some services where sshguard might be parsing the logs wrongly.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."sshguard.conf".text =
      let
        backend = if config.networking.nftables.enable then "sshg-fw-nft-sets" else "sshg-fw-ipset";
      in
      ''
        BACKEND="${pkgs.sshguard}/libexec/${backend}"
        LOGREADER="${lib.getExe' pkgs.coreutils "cat"} /run/sshguard-logger/sshguard-logger"
      '';

    systemd.slices."system-sshguard" = {
      description = "SSHGuard Intrusion Prevention Slice";
    };

    systemd.services.sshguard-logger = {
      description = "SSHGuard Intrusion Prevention Log Provider";
      wantedBy = [ "sshguard.service" ];
      requires = [ "sshguard-logger.socket" ];
      after = [ "sshguard-logger.socket" ];

      environment.LANG = "C";

      serviceConfig = {
        Slice = "system-sshguard";
        Type = "simple";

        Sockets = "sshguard-logger.socket";
        StandardOutput = "fd:sshguard-logger.socket";
        StandardError = "journal";
        SyslogIdentifier = "sshguard-logger";

        ExecStart =
          let
            logTargets = lib.partition ({ type, ... }: type == "service-name") cfg.services;
            args = lib.cli.toGNUCommandLineShell { } {
              all = true;
              follow = true;
              priority = "info";
              output = "cat";
              lines = 1;
              unit = map (x: x.name) logTargets.right;
              identifier = map (x: x.name) logTargets.wrong;
            };
          in
          if cfg.enableInspectableLogStream then
            pkgs.writeShellScript "sshguard-logger-start" "${config.systemd.package}/bin/journalctl ${args} |& ${lib.getExe' pkgs.coreutils "tee"} >(cat 1>&2)"
          else
            "${config.systemd.package}/bin/journalctl ${args}";

        DynamicUser = true;
        SupplementaryGroups = [
          # allow to read the systemd journal for opentelemetry-collector
          "systemd-journal"
        ];
      };
    };

    systemd.sockets.sshguard-logger = {
      description = "SSHGuard Intrusion Prevention Log Provider";
      socketConfig = {
        ListenFIFO = "/run/sshguard-logger/sshguard-logger";
        SocketMode = "0600";
      };
    };

    systemd.services.sshguard = {
      description = "SSHGuard Intrusion Prevention System";

      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "sshguard-logger.socket"
      ];
      requires = [
        "sshguard-logger.socket"
        "sshguard-logger.service"
      ];
      partOf = lib.optional config.networking.firewall.enable "firewall.service";

      restartTriggers = [ config.environment.etc."sshguard.conf".source ];

      path =
        with pkgs;
        if config.networking.nftables.enable then
          [
            nftables
            iproute2
          ]
        else
          [
            iptables
            ipset
            iproute2
          ];

      documentation = [
        "man:sshguard(8)"
        "man:sshguard-setup(8)"
      ];

      serviceConfig = {
        Slice = "system-sshguard";
        Type = "simple";

        # The sshguard ipsets must exist before we invoke
        # iptables. sshguard creates the ipsets after startup if
        # necessary, but if we let sshguard do it, we can't reliably add
        # the iptables rules because postStart races with the creation
        # of the ipsets. So instead, we create both the ipsets and
        # firewall rules before sshguard starts.
        ExecStartPre =
          lib.optionals config.networking.firewall.enable [
            "${pkgs.ipset}/bin/ipset -quiet create -exist sshguard4 hash:net family inet"
            "${pkgs.iptables}/bin/iptables  -I INPUT -m set --match-set sshguard4 src -j DROP"
          ]
          ++ lib.optionals (config.networking.firewall.enable && config.networking.enableIPv6) [
            "${pkgs.ipset}/bin/ipset -quiet create -exist sshguard6 hash:net family inet6"
            "${pkgs.iptables}/bin/ip6tables -I INPUT -m set --match-set sshguard6 src -j DROP"
          ];
        ExecStart =
          let
            args = lib.concatStringsSep " " (
              [
                "-a ${toString cfg.attack_threshold}"
                "-p ${toString cfg.blocktime}"
                "-s ${toString cfg.detection_time}"
                (lib.optionalString (
                  cfg.blacklist_threshold != null
                ) "-b ${toString cfg.blacklist_threshold}:${cfg.blacklist_file}")
              ]
              ++ (map (name: "-w ${lib.escapeShellArg name}") cfg.whitelist)
            );
          in
          "${pkgs.sshguard}/bin/sshguard ${args}";
        ExecStopPost =
          lib.optionals config.networking.firewall.enable [
            "${pkgs.iptables}/bin/iptables  -D INPUT -m set --match-set sshguard4 src -j DROP"
            "${pkgs.ipset}/bin/ipset -quiet destroy sshguard4"
          ]
          ++ lib.optionals (config.networking.firewall.enable && config.networking.enableIPv6) [
            "${pkgs.iptables}/bin/ip6tables -D INPUT -m set --match-set sshguard6 src -j DROP"
            "${pkgs.ipset}/bin/ipset -quiet destroy sshguard6"
          ];
        Restart = "always";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";
        RuntimeDirectory = "sshguard";
        StateDirectory = "sshguard";
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
      };
    };
  };
}
