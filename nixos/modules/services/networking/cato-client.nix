{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkPackageOption;

  cfg = config.services.cato-client;
in
{
  options.services.cato-client = {
    enable = mkEnableOption "cato-client service";
    package = mkPackageOption pkgs "cato-client" { };
  };

  config = mkIf cfg.enable {
    users = {
      groups.cato-client = { };
    };

    environment.systemPackages = [
      cfg.package
    ];

    systemd.services.cato-client = {
      enable = true;
      description = "Cato Networks Linux client - connects tunnel to Cato cloud";
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        User = "root"; # Note: daemon runs as root, tools sticky to group
        Group = "cato-client";
        ExecStart = "${cfg.package}/bin/cato-clientd systemd";
        WorkingDirectory = "${cfg.package}";
        Restart = "always";

        # Cato client seems to do the following:
        # - Look in each user's ~/.cato/ for configuration and keys
        # - Write to /var/log/cato-client.log
        # - Create and use sockets /var/run/cato-sdp.i, /var/run/cato-sdp.o
        # - Read and Write to /opt/cato/ for runtime settings
        # - Read /etc/systemd/resolved.conf (but fine if fails)
        # - Restart systemd-resolved (also fine if doesn't exist)

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectSystem = true;
      };

      wantedBy = [ "multi-user.target" ];
    };

    # set up Security wrapper Same as intended in deb post install
    security.wrappers.cato-clientd = {
      source = "${cfg.package}/bin/cato-clientd";
      owner = "root";
      group = "cato-client";
      permissions = "u+rwx,g+rwx"; # 770
      setgid = true;
    };

    security.wrappers.cato-sdp = {
      source = "${cfg.package}/bin/cato-sdp";
      owner = "root";
      group = "cato-client";
      permissions = "u+rwx,g+rx,a+rx"; # 755
      setgid = true;
    };
  };
}
