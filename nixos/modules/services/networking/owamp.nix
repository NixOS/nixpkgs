{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.owamp;
in
{

  ###### interface

  options = {
    services.owamp.enable = mkEnableOption ''Enable OWAMP server'';
  };


  ###### implementation

  config = mkIf cfg.enable {
    users.users = singleton {
      name = "owamp";
      group = "owamp";
      description = "Owamp daemon";
      isSystemUser = true;
    };

    users.groups = singleton {
      name = "owamp";
    };

    systemd.services.owamp = {
      description = "Owamp server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart="${pkgs.owamp}/bin/owampd -R /run/owamp -d /run/owamp -v -Z ";
        PrivateTmp = true;
        Restart = "always";
        Type="simple";
        User = "owamp";
        Group = "owamp";
        RuntimeDirectory = "owamp";
        StateDirectory = "owamp";
        AmbientCapabilities = "cap_net_bind_service";
      };
    };
  };
}
