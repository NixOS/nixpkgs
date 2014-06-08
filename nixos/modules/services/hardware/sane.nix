{ config, lib, pkgs, ... }:

with lib;

let

  pkg = if config.hardware.sane.snapshot then pkgs.saneBackendsGit else pkgs.saneBackends;
  backends = [ pkg ] ++ config.hardware.sane.extraBackends;
  saneConfig = pkgs.mkSaneConfig { paths = backends; };

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

    hardware.sane.extraBackends = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "Packages providing extra SANE backends to enable.";
    };

  };


  ###### implementation

  config = mkIf config.hardware.sane.enable {

    environment.systemPackages = backends;
    environment.variables = {
      SANE_CONFIG_DIR = mkDefault "${saneConfig}/etc/sane.d";
      LD_LIBRARY_PATH = [ "${saneConfig}/lib/sane" ];
    };
    services.udev.packages = backends;

    users.extraGroups."scanner".gid = config.ids.gids.scanner;

  };

}
