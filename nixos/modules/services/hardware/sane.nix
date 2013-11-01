{ config, pkgs, ... }:

with pkgs.lib;

let

  pkg = if config.hardware.sane.snapshot then pkgs.saneBackendsGit else pkgs.saneBackends;

in

{

  ###### interface

  options = {

    hardware.sane.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable support for SANE scanners.";
    };

    hardware.sane.snapshot = mkOption {
      type = types.bool;
      default = false;
      description = "Use a development snapshot of SANE scanner drivers.";
    };

  };


  ###### implementation

  config = mkIf config.hardware.sane.enable {

    environment.systemPackages = [ pkg ];
    services.udev.packages = [ pkg ];

    users.extraGroups."scanner".gid = config.ids.gids.scanner;

  };

}
