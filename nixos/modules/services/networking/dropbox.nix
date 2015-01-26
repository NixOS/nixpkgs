{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dropbox;
in
{

  ###### interface

  options = {
    services.dropbox = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the local dropbox service. You'll need to run dropbox 
          manually once to setup your account credentials.
        '';
      };
      user = mkOption {
        default = "dropbox";
        description = ''
          Dropbox will be run under this user (user must exist,
          this can be your user name).
        '';
      };


    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.dropbox =
      {
        description = "dropbox service";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "always";
          PermissionsStartOnly = true;
          User = "${cfg.user}";
          ExecStart = "${pkgs.dropbox}/bin/dropbox";
        };
      };
  };
}
