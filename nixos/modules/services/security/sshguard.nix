{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sshguard;

  configFile =
    let
      args = lib.concatStringsSep " " (
        [
          "-afb"
          "-p info"
          "-o cat"
          "-n1"
        ]
        ++ (map (name: "-t ${lib.escapeShellArg name}") cfg.services)
      );
      backend = if config.networking.nftables.enable then "sshg-fw-nft-sets" else "sshg-fw-ipset";
    in
    pkgs.writeText "sshguard.conf" ''
      BACKEND="${pkgs.sshguard}/libexec/${backend}"
      LOGREADER="LANG=C ${config.systemd.package}/bin/journalctl ${args}"
    '';

in
{

  ###### interface

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
        default = [ "sshd" ];
        example = [
          "sshd"
          "exim"
        ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Systemd services sshguard should receive logs of.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.etc."sshguard.conf".source = configFile;

    systemd.services.sshguard = {
      description = "SSHGuard brute-force attacks protection system";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      partOf = lib.optional config.networking.firewall.enable "firewall.service";

      restartTriggers = [ configFile ];

      path =
        with pkgs;
        if config.networking.nftables.enable then
          [
            nftables
            iproute2
            systemd
          ]
        else
          [
            iptables
            ipset
            iproute2
            systemd
          ];

      # The sshguard ipsets must exist before we invoke
      # iptables. sshguard creates the ipsets after startup if
      # necessary, but if we let sshguard do it, we can't reliably add
      # the iptables rules because postStart races with the creation
      # of the ipsets. So instead, we create both the ipsets and
      # firewall rules before sshguard starts.
      preStart =
        lib.optionalString config.networking.firewall.enable ''
          ${pkgs.ipset}/bin/ipset -quiet create -exist sshguard4 hash:net family inet
          ${pkgs.iptables}/bin/iptables  -I INPUT -m set --match-set sshguard4 src -j DROP
        ''
        + lib.optionalString (config.networking.firewall.enable && config.networking.enableIPv6) ''
          ${pkgs.ipset}/bin/ipset -quiet create -exist sshguard6 hash:net family inet6
          ${pkgs.iptables}/bin/ip6tables -I INPUT -m set --match-set sshguard6 src -j DROP
        '';

      postStop =
        lib.optionalString config.networking.firewall.enable ''
          ${pkgs.iptables}/bin/iptables  -D INPUT -m set --match-set sshguard4 src -j DROP
          ${pkgs.ipset}/bin/ipset -quiet destroy sshguard4
        ''
        + lib.optionalString (config.networking.firewall.enable && config.networking.enableIPv6) ''
          ${pkgs.iptables}/bin/ip6tables -D INPUT -m set --match-set sshguard6 src -j DROP
          ${pkgs.ipset}/bin/ipset -quiet destroy sshguard6
        '';

      unitConfig.Documentation = "man:sshguard(8)";

      serviceConfig = {
        Type = "simple";
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
