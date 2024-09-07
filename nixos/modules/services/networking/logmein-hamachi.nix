{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.logmein-hamachi;

in

{

  ###### interface

  options = {

    services.logmein-hamachi.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Whether to enable LogMeIn Hamachi, a proprietary
          (closed source) commercial VPN software.
        '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.logmein-hamachi = {
      description = "LogMeIn Hamachi Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.logmein-hamachi}/bin/hamachid";
      };
    };

    environment.systemPackages = [ pkgs.logmein-hamachi ];

  };

}
