{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nzbget;
  pkg = pkgs.nzbget;
  stateDir = "/var/lib/nzbget";
  configFile = "${stateDir}/nzbget.conf";
  configOpts = concatStringsSep " " (mapAttrsToList (name: value: "-o ${name}=${value}") nixosOpts);

  nixosOpts = {
    # allows nzbget to run as a "simple" service
    OutputMode = "loggable";
    # use journald for logging
    WriteLog = "none";
    ErrorTarget = "screen";
    WarningTarget = "screen";
    InfoTarget = "screen";
    DetailTarget = "screen";
    # required paths
    ConfigTemplate = "${pkg}/share/nzbget/nzbget.conf";
    WebDir = "${pkg}/share/nzbget/webui";
    # nixos handles package updates
    UpdateCheck = "none";
  };

in
{
  # interface

  options = {
    services.nzbget = {
      enable = mkEnableOption "NZBGet";

      user = mkOption {
        type = types.str;
        default = "nzbget";
        description = "User account under which NZBGet runs";
      };

      group = mkOption {
        type = types.str;
        default = "nzbget";
        description = "Group under which NZBGet runs";
      };
    };
  };

  # implementation

  config = mkIf cfg.enable {
    systemd.services.nzbget = {
      description = "NZBGet Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        unrar
        p7zip
      ];
      preStart = ''
        if [ ! -f ${configFile} ]; then
          ${pkgs.coreutils}/bin/install -m 0700 ${pkg}/share/nzbget/nzbget.conf ${configFile}
        fi
      '';

      serviceConfig = {
        StateDirectory = "nzbget";
        StateDirectoryMode = "0750";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        Restart = "on-failure";
        ExecStart = "${pkg}/bin/nzbget --server --configfile ${stateDir}/nzbget.conf ${configOpts}";
        ExecStop = "${pkg}/bin/nzbget --quit";
      };
    };

    users.users = mkIf (cfg.user == "nzbget") {
      nzbget = {
        home = stateDir;
        group = cfg.group;
        uid = config.ids.uids.nzbget;
      };
    };

    users.groups = mkIf (cfg.group == "nzbget") {
      nzbget = {
        gid = config.ids.gids.nzbget;
      };
    };
  };
}
