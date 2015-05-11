{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    services.resolved.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable the systemd DNS resolver daemon.
      '';
    };

  };

  config = mkIf config.services.resolved.enable {

    systemd.additionalUpstreamSystemUnits = [ "systemd-resolved.service" ];

    systemd.services.systemd-resolved = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
    };

    environment.etc."systemd/resolved.conf".text = ''
      [Resolve]
      DNS=${concatStringsSep " " config.networking.nameservers}
    '';

  };

}
