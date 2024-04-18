{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.soundmodem;
in
{
  options = {
    programs.soundmodem = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add Soundmodem to the global environment and configure a
          wrapper for 'soundmodemconfig' for users in the 'soundmodem' group.
        '';
      };
      package = mkPackageOption pkgs "soundmodem" { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.soundmodem = { };

    security.wrappers.soundmodemconfig = {
      source = "${cfg.package}/bin/soundmodemconfig";
      owner = "root";
      group = "soundmodem";
      permissions = "u+rx,g+x";
    };
  };
}
