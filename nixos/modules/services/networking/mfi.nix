{ config, lib, pkgs, utils, ... }:
with lib;
let
  name = "Ubiquiti mFi Controller";
  cfg = config.services.mfi;
  stateDir = "/var/lib/mfi";
  # XXX 2 runtime exceptions using jre8: JSPException on GET / ; can't initialize ./data/keystore on first run.
  cmd = "@${pkgs.jre7}/bin/java java -jar ${stateDir}/lib/ace.jar";
  mountPoints = [
    { what = "${pkgs.mfi}/dl"; where = "${stateDir}/dl"; }
    { what = "${pkgs.mfi}/lib"; where = "${stateDir}/lib"; }
    { what = "${pkgs.mongodb248}/bin"; where = "${stateDir}/bin"; }
  ];
  systemdMountPoints = map (m: "${utils.escapeSystemdPath m.where}.mount") mountPoints;
  ports = [ 6080 6880 6443 6843 ];
in
{
  options = {
    services.mfi = {
      enable = mkEnableOption name;
      openPorts = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to open TCP ports ${concatMapStrings (a: "${toString a} ") ports}for the services.";
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = mkIf config.services.mfi.openPorts ports;

    users.users.mfi = {
      uid = config.ids.uids.mfi;
      description = "mFi controller daemon user";
      home = "${stateDir}";
    };

    # We must create the binary directories as bind mounts instead of symlinks
    # This is because the controller resolves all symlinks to absolute paths
    # to be used as the working directory.
    systemd.mounts = map ({ what, where }: {
        bindsTo = [ "mfi.service" ];
        partOf = [ "mfi.service" ];
        unitConfig.RequiresMountsFor = stateDir;
        options = "bind";
        what = what;
        where = where;
      }) mountPoints;

    systemd.services.mfi = {
      description = "mFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ systemdMountPoints;
      partOf = systemdMountPoints;
      bindsTo = systemdMountPoints;
      unitConfig.RequiresMountsFor = stateDir;

      preStart = ''
        # Clear ./webapps each run.
        rm -rf                               "${stateDir}/webapps"
        mkdir -p                             "${stateDir}/webapps"
        ln -s "${pkgs.mfi}/webapps/ROOT.war" "${stateDir}/webapps"

        # Copy initial config only once.
        test -e "${stateDir}/conf" || cp -ar "${pkgs.mfi}/conf" "${stateDir}/conf"
        test -e "${stateDir}/data" || cp -ar "${pkgs.mfi}/data" "${stateDir}/data"

        # Fix Permissions.
        # (Bind-mounts cause errors; ignore exit codes)
        chown -fR mfi:      "${stateDir}" || true
        chmod -fR u=rwX,go= "${stateDir}" || true
      '';

      postStop = ''
        rm -rf "${stateDir}/webapps"
      '';

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cmd} start";
        ExecStop = "${cmd} stop";
        User = "mfi";
        PermissionsStartOnly = true;
        UMask = "0077";
        WorkingDirectory = "${stateDir}";
      };
    };
  };
}
