{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sshguard;
in {

  ###### interface

  options = {

    services.sshguard = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable the sshguard service.";
      };

      attack_threshold = mkOption {
        default = 30;
        type = types.int;
        description = ''
            Block attackers when their cumulative attack score exceeds threshold. Most attacks have a score of 10.
          '';
      };

      blacklist_threshold = mkOption {
        default = null;
        example = 120;
        type = types.nullOr types.int;
        description = ''
            Blacklist an attacker when its score exceeds threshold. Blacklisted addresses are loaded from and added to blacklist-file.
          '';
      };

      blacklist_file = mkOption {
        default = "/var/lib/sshguard/blacklist.db";
        type = types.path;
        description = ''
            Blacklist an attacker when its score exceeds threshold. Blacklisted addresses are loaded from and added to blacklist-file.
          '';
      };

      blocktime = mkOption {
        default = 120;
        type = types.int;
        description = ''
            Block attackers for initially blocktime seconds after exceeding threshold. Subsequent blocks increase by a factor of 1.5.

            sshguard unblocks attacks at random intervals, so actual block times will be longer.
          '';
      };

      detection_time = mkOption {
        default = 1800;
        type = types.int;
        description = ''
            Remember potential attackers for up to detection_time seconds before resetting their score.
          '';
      };

      whitelist = mkOption {
        default = [ ];
        example = [ "198.51.100.56" "198.51.100.2" ];
        type = types.listOf types.str;
        description = ''
            Whitelist a list of addresses, hostnames, or address blocks.
          '';
      };

      services = mkOption {
        default = [ "sshd" ];
        example = [ "sshd" "exim" ];
        type = types.listOf types.str;
        description = ''
            Systemd services sshguard should receive logs of.
          '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.sshguard pkgs.iptables pkgs.ipset ];

    environment.etc."sshguard.conf".text = let 
        list_services = ( name:  "-t ${name} ");
      in ''
        BACKEND="${pkgs.sshguard}/libexec/sshg-fw-ipset"
        LOGREADER="LANG=C ${pkgs.systemd}/bin/journalctl -afb -p info -n1 ${toString (map list_services cfg.services)} -o cat"
      '';

    systemd.services.sshguard =
      { description = "SSHGuard brute-force attacks protection system";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        partOf = optional config.networking.firewall.enable "firewall.service";

        path = [ pkgs.iptables pkgs.ipset pkgs.iproute pkgs.systemd ];

        postStart = ''
          mkdir -p /var/lib/sshguard
          ${pkgs.ipset}/bin/ipset -quiet create -exist sshguard4 hash:ip family inet
          ${pkgs.ipset}/bin/ipset -quiet create -exist sshguard6 hash:ip family inet6
          ${pkgs.iptables}/bin/iptables -I INPUT -m set --match-set sshguard4 src -j DROP
          ${pkgs.iptables}/bin/ip6tables -I INPUT -m set --match-set sshguard6 src -j DROP
        '';

        preStop = ''
          ${pkgs.iptables}/bin/iptables -D INPUT -m set --match-set sshguard4 src -j DROP
          ${pkgs.iptables}/bin/ip6tables -D INPUT -m set --match-set sshguard6 src -j DROP
        '';

        unitConfig.Documentation = "man:sshguard(8)";

        serviceConfig = {
            Type = "simple";
            ExecStart = let
                list_whitelist = ( name:  "-w ${name} ");
              in ''
                 ${pkgs.sshguard}/bin/sshguard -a ${toString cfg.attack_threshold} ${optionalString (cfg.blacklist_threshold != null) "-b ${toString cfg.blacklist_threshold}:${cfg.blacklist_file} "}-i /run/sshguard/sshguard.pid -p ${toString cfg.blocktime} -s ${toString cfg.detection_time} ${toString (map list_whitelist cfg.whitelist)}
              '';
            PIDFile = "/run/sshguard/sshguard.pid";
            Restart = "always";

            ReadOnlyDirectories = "/";
            ReadWriteDirectories = "/run/sshguard /var/lib/sshguard";
            RuntimeDirectory = "sshguard";
            CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
         };
      };
  };
}
