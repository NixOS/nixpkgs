{ config, pkgs, lib, ... }:
let
  cfg = config.services.netclient;
in
{
  meta.maintainers = with lib.maintainers; [ wexder nazarewk ];

  options.services.netclient = {
    enable = lib.mkEnableOption (lib.mdDoc "Netclient Daemon");
    package = lib.mkPackageOption pkgs "netclient" { };

    verbosity = lib.mkOption {
      type = with lib.types; enum [ 1 2 3 4 ];
      default = config.services.netmaker.verbosity;
      defaultText = lib.literalExpression ''config.services.netmaker.verbosity'';
      description = lib.mdDoc ''
        Verbosity level of Netclient logging.
      '';
    };

    firewall.trusted = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = lib.mdDoc ''
        Trusts all traffic coming from Netmaker interface.

        See the example for setting up your own untrusted rules.
      '';
      example = lib.literalExpression ''
        # setting up untrusted firewall:
        {
          services.netclient.firewall.trusted = false;

          networking.firewall.interfaces."''${config.services.netclient.firewall.interface}+" = {
            allowedTCPPorts = [ 80 443 ];
            allowedTCPPortRanges = [];
            allowedUDPPorts = [];
            allowedUDPPortRanges = [
              {
                from = 60000;
                to = 61000;
              }
            ];
          };
        }
      '';
    };
    firewall.interface = lib.mkOption {
      type = with lib.types; str;
      internal = true;
      readOnly = true;
      default = "netmaker";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.netclient = {
      path = let fw = config.networking.firewall; in lib.optionals fw.enable [ fw.package ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      description = "Netclient Daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} daemon --verbosity=${builtins.toString cfg.verbosity}";
        Restart = "on-failure";
        RestartSec = "15s";
      };
    };
    networking.networkmanager.unmanaged = [ "interface-name:${cfg.firewall.interface}*" ];
    networking.firewall.trustedInterfaces = with cfg.firewall; lib.optional trusted "${interface}+";
  };
}
