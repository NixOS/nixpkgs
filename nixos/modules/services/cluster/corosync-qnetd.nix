{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.corosync-qnetd;
in
{
  meta.maintainers = [ lib.maintainers.hddq ];

  options.services.corosync-qnetd = {
    enable = lib.mkEnableOption "Corosync Qdevice Network Daemon";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the default port (5403) in the firewall
        for the Corosync Qdevice Network Daemon.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.corosync-qdevice
      pkgs.nssTools
    ];

    users.groups.coroqnetd = { };
    users.users.coroqnetd = {
      isSystemUser = true;
      group = "coroqnetd";
      description = "Corosync QNetd daemon user";
      home = "/var/lib/corosync-qnetd";
    };

    environment.etc."corosync/qnetd".source = "/var/lib/corosync-qnetd";

    systemd.services.corosync-qnetd = {
      description = "Corosync Qdevice Network Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.nssTools
        pkgs.corosync-qdevice
      ];

      serviceConfig = {
        StateDirectory = "corosync-qnetd";
        RuntimeDirectory = "corosync-qnetd";
        ExecStartPre = [
          "${pkgs.writeShellScript "corosync-qnetd-prestart" ''
            if [ ! -f /var/lib/corosync-qnetd/nssdb/cert9.db ]; then
              ${pkgs.corosync-qdevice}/bin/corosync-qnetd-certutil -i
            fi
          ''}"
        ];
        ExecStart = "${pkgs.corosync-qdevice}/bin/corosync-qnetd -f";
        User = "coroqnetd";
        Group = "coroqnetd";
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 5403 ];
  };
}
