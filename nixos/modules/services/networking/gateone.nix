{ config, lib, pkgs, ...}:
let
  cfg = config.services.gateone;
in
{
options = {
    services.gateone = {
      enable = lib.mkEnableOption "GateOne server";
      pidDir = lib.mkOption {
        default = "/run/gateone";
        type = lib.types.path;
        description = "Path of pid files for GateOne.";
      };
      settingsDir = lib.mkOption {
        default = "/var/lib/gateone";
        type = lib.types.path;
        description = "Path of configuration files for GateOne.";
      };
    };
};
config = lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs.pythonPackages; [
    gateone pkgs.openssh pkgs.procps pkgs.coreutils pkgs.cacert];

  users.users.gateone = {
    description = "GateOne privilege separation user";
    uid = config.ids.uids.gateone;
    home = cfg.settingsDir;
  };
  users.groups.gateone.gid = config.ids.gids.gateone;

  systemd.services.gateone = with pkgs; {
    description = "GateOne web-based terminal";
    path = [ pythonPackages.gateone nix openssh procps coreutils ];
    preStart = ''
      if [ ! -d ${cfg.settingsDir} ] ; then
        mkdir -m 0750 -p ${cfg.settingsDir}
        chown -R gateone:gateone ${cfg.settingsDir}
      fi
      if [ ! -d ${cfg.pidDir} ] ; then
        mkdir -m 0750 -p ${cfg.pidDir}
        chown -R gateone:gateone ${cfg.pidDir}
      fi
      '';
    #unitConfig.RequiresMountsFor = "${cfg.settingsDir}";
    serviceConfig = {
      ExecStart = ''${pythonPackages.gateone}/bin/gateone --settings_dir=${cfg.settingsDir} --pid_file=${cfg.pidDir}/gateone.pid --gid=${toString config.ids.gids.gateone} --uid=${toString config.ids.uids.gateone}'';
      User = "gateone";
      Group = "gateone";
      WorkingDirectory = cfg.settingsDir;
    };

    wantedBy = [ "multi-user.target" ];
    requires = [ "network.target" ];
  };
};
}

