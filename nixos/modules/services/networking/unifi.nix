{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.unifi;
  stateDir = "/var/lib/unifi";
  cmd = "@${pkgs.icedtea7_jre}/bin/java java -jar ${stateDir}/lib/ace.jar";
in
{

  options = {

    services.unifi.enable = mkOption {
      type = types.uniq types.bool;
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

    systemd.mounts = [
      {
        unitConfig.StopWhenUnneeded = true;
        requiredBy = [ "unifi.service" ];
        what = "${pkgs.unifi}/dl";
        where = "${stateDir}/dl";
        options = "bind";
      }
      {
        unitConfig.StopWhenUnneeded = true;
        requiredBy = [ "unifi.service" ];
        what = "${pkgs.unifi}/lib";
        where = "${stateDir}/lib";
        options = "bind";
      }
      {
        unitConfig.StopWhenUnneeded = true;
        requiredBy = [ "unifi.service" ];
        what = "${pkgs.mongodb}/bin";
        where = "${stateDir}/bin";
        options = "bind";
      }
    ];

    systemd.services.unifi = {
      description = "UniFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        # Ensure privacy of state
        chown unifi "${stateDir}"
        chmod 0700 "${stateDir}"

        # Create the volatile webapps
        mkdir -p "${stateDir}/webapps"
        chown unifi "${stateDir}/webapps"
        ln -s "${pkgs.unifi}/webapps/ROOT.war" "${stateDir}/webapps/ROOT.war"
      '';

      postStop = ''
        rm "${stateDir}/webapps/ROOT.war"
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
