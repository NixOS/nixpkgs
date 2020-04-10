{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.dellCommandConfigure;

  configFile = pkgs.writeTextFile {
    name = "omreg.cfg";
    text = ''
      hapi.omilcore.version=9.3.0
      hapi.configtool=${pkgs.dell-command-configure}/bin/dchcfg
      hapi.installpath=${pkgs.dell-command-configure}
      hapi.logpath=${cfg.logpath}
      hapi.vardatapath=${cfg.vardatapath}

      openmanage.openipmi.kernel.2.4.x.ver_min_major=35
      openmanage.openipmi.kernel.2.4.x.ver_min_minor=13
      openmanage.openipmi.kernel.2.6.x.ver_min_major=33
      openmanage.openipmi.kernel.2.6.x.ver_min_minor=13
      openmanage.openipmi.kernel.ver_min_major=2
      openmanage.openipmi.kernel.ver_min_minor=6
      openmanage.openipmi.kernel.ver_min_patch=15
      openmanage.openipmi.rhel3.ver_min_major=35
      openmanage.openipmi.rhel3.ver_min_minor=13
      openmanage.openipmi.rhel4.ver_min_major=33
      openmanage.openipmi.rhel4.ver_min_minor=13
    '';
  };
in

{
  options = {
    hardware.dellCommandConfigure = {
      enable = mkEnableOption "Dell Command Configure";

      logpath = mkOption {
        type = types.path;
        default = "/var/log/openmanage";
        description = "Log path.";
      };

      vardatapath = mkOption {
        type = types.path;
        default = "/var/lib/openmanage";
        description = "Data directory path.";
      };
    };
  };

  config = mkIf config.hardware.dellCommandConfigure.enable {
    environment.systemPackages = [ pkgs.dell-command-configure ];

    system.activationScripts.dellCommandConfigure =
      ''
        mkdir -p /opt/dell/srvadmin/etc
        ln -fs ${configFile} /opt/dell/srvadmin/etc/omreg.cfg
        mkdir -p ${cfg.logpath}
        mkdir -p ${cfg.vardatapath}
      '';
  };

  meta = {
    maintainers = with maintainers; [ maxeaubrey ];
  };
}
