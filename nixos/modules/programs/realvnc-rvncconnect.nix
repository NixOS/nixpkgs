{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.realvnc-rvncconnect;
in
{
  options.programs.realvnc-rvncconnect = {
    enable = lib.mkEnableOption "RealVNC Connect server functionality";

    package = lib.mkPackageOption pkgs "realvnc-rvncconnect" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall ports for RealVNC Connect.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5900 ];
      allowedUDPPorts = [ 5900 ];
    };

    security.pam.services.rvncconnect = { };

    systemd.services.rvncserver-x11-serviced = {
      description = "RealVNC Connect service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/lib/rvncconnect/rvncserver-x11-serviced -fg";
        Restart = "on-failure";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        KillMode = "process";
      };
      path = with pkgs; [
        sudo
        xorg.xrandr
      ];
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = pkgs.realvnc-rvncconnect.meta.maintainers;
}
