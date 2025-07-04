{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.librenms-agent;
in
{
  options.services.librenms-agent = {
    enable = lib.mkEnableOption "LibreNMS agent";

    package = lib.mkPackageOption pkgs "librenms-agent" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 6556;
      description = "Port where the LibreNMS Agent will listen.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open port for LibreNMS Agent.
      '';
    };

    ipAddressAllow = lib.mkOption {
      example = [ "192.168.1.0/24" ];
      type = lib.types.listOf lib.types.str;
      description = ''
        Allows access to the LibreNMS Agent only for the given addresses.
        An empty list will allow all.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.sockets.librenms-agent = {
      description = "Check_MK LibreNMS Agent Socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = toString cfg.port;
        Accept = "yes";
      };
    };

    systemd.services."librenms-agent@" = {
      description = "Check_MK LibreNMS Agent Service";
      after = [
        "network.target"
        "librenms-agent.socket"
      ];
      requires = [ "librenms-agent.socket" ];
      serviceConfig = lib.mkMerge [
        {
          ExecStart = lib.getExe cfg.package;
          StandardOutput = "socket";
        }
        (lib.mkIf (cfg.ipAddressAllow != [ ]) {
          IPAddressDeny = "any";
          IPAddressAllow = cfg.ipAddressAllow;
        })
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = [ lib.maintainers.Nebucatnetzer ];

}
