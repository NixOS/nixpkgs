{ config, lib, pkgs, ... }:

with lib;

let

  pkg = if config.hardware.sane.snapshot
    then pkgs.sane-backends-git
    else pkgs.sane-backends;
  backends = [ pkg ] ++ config.hardware.sane.extraBackends;
  saneConfig = pkgs.mkSaneConfig { paths = backends; };

in

{

  ###### interface

  options = {

    hardware.sane.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable support for SANE scanners.

        <note><para>
          Users in the "scanner" group will gain access to the scanner.
        </para></note>
      '';
    };

    hardware.sane.snapshot = mkOption {
      type = types.bool;
      default = false;
      description = "Use a development snapshot of SANE scanner drivers.";
    };

    hardware.sane.extraBackends = mkOption {
      type = types.listOf types.path;
      default = [];
      description = ''
        Packages providing extra SANE backends to enable.

        <note><para>
          The example contains the package for HP scanners.
        </para></note>
      '';
      example = literalExample "[ pkgs.hplipWithPlugin ]";
    };

    hardware.sane.configDir = mkOption {
      type = types.string;
      description = "The value of SANE_CONFIG_DIR.";
    };

  };


  ###### implementation

  config = mkIf config.hardware.sane.enable {

    hardware.sane.configDir = mkDefault "${saneConfig}/etc/sane.d";

    environment.systemPackages = backends;
    environment.sessionVariables = {
      SANE_CONFIG_DIR = config.hardware.sane.configDir;
      LD_LIBRARY_PATH = [ "${saneConfig}/lib/sane" ];
    };
    services.udev.packages = backends;

    users.extraGroups."scanner".gid = config.ids.gids.scanner;

  };

}
