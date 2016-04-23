{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.unifi;
  stateDir = "/var/lib/unifi";
  cmd = "@${pkgs.jre}/bin/java java -jar ${stateDir}/lib/ace.jar";
  mountPoints = [
    {
      what = "${pkgs.unifi}/dl";
      where = "${stateDir}/dl";
    }
    {
      what = "${pkgs.unifi}/lib";
      where = "${stateDir}/lib";
    }
    {
      what = "${pkgs.mongodb}/bin";
      where = "${stateDir}/bin";
    }
  ];
  systemdMountPoints = map (m: "${utils.escapeSystemdPath m.where}.mount") mountPoints;
in
{

  options = {

    services.unifi.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not to enable the unifi controller service.
      '';
    };

  };

  config = mkIf cfg.enable {

    users.extraUsers.unifi = {
      uid = config.ids.uids.unifi;
      description = "UniFi controller daemon user";
      home = "${stateDir}";
    };

    # We must create the binary directories as bind mounts instead of symlinks
    # This is because the controller resolves all symlinks to absolute paths
    # to be used as the working directory.
    systemd.mounts = map ({ what, where }: {
        bindsTo = [ "unifi.service" ];
        partOf = [ "unifi.service" ];
        unitConfig.RequiresMountsFor = stateDir;
        options = "bind";
        what = what;
        where = where;
      }) mountPoints;

    systemd.services.unifi = {
      description = "UniFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ systemdMountPoints;
      partOf = systemdMountPoints;
      bindsTo = systemdMountPoints;
      unitConfig.RequiresMountsFor = stateDir;
      # This a HACK to fix missing dependencies of dynamic libs extracted from jars
      environment.LD_LIBRARY_PATH = with pkgs.stdenv; "${cc.cc.lib}/lib";

      preStart = ''
        # Ensure privacy of state
        chown unifi "${stateDir}"
        chmod 0700 "${stateDir}"

        # Create the volatile webapps
        rm -rf "${stateDir}/webapps"
        mkdir -p "${stateDir}/webapps"
        chown unifi "${stateDir}/webapps"
        ln -s "${pkgs.unifi}/webapps/ROOT" "${stateDir}/webapps/ROOT"
      '';

      postStop = ''
        rm -rf "${stateDir}/webapps"
      '';

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cmd} start";
        ExecStop = "${cmd} stop";
        User = "unifi";
        PermissionsStartOnly = true;
        UMask = "0077";
        WorkingDirectory = "${stateDir}";
      };
    };

  };

}
