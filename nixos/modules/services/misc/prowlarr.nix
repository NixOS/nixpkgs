{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prowlarr;

in
{
  options = {
    services.prowlarr = {
      enable = mkEnableOption (lib.mdDoc "Prowlarr");

<<<<<<< HEAD
      package = mkPackageOptionMD pkgs "prowlarr" { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Prowlarr web interface.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "prowlarr";
<<<<<<< HEAD
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data=/var/lib/prowlarr";
=======
        ExecStart = "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=/var/lib/prowlarr";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };
  };
}
