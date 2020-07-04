{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.peerflix;

  configFile = pkgs.writeText "peerflix-config.json" ''
    {
      "connections": 50,
      "tmp": "${cfg.downloadDir}"
    }
  '';

in {

  ###### interface

  options.services.peerflix = {
    enable = mkOption {
      description = "Whether to enable peerflix service.";
      default = false;
      type = types.bool;
    };

    stateDir = mkOption {
      description = "Peerflix state directory.";
      default = "/var/lib/peerflix";
      type = types.path;
    };

    downloadDir = mkOption {
      description = "Peerflix temporary download directory.";
      default = "${cfg.stateDir}/torrents";
      type = types.path;
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - peerflix - - -"
    ];

    systemd.services.peerflix = {
      description = "Peerflix Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment.HOME = cfg.stateDir;

      preStart = ''
        mkdir -p "${cfg.stateDir}"/{torrents,.config/peerflix-server}
        ln -fs "${configFile}" "${cfg.stateDir}/.config/peerflix-server/config.json"
      '';

      serviceConfig = {
        ExecStart = "${pkgs.nodePackages.peerflix-server}/bin/peerflix-server";
        User = "peerflix";
      };
    };

    users.users.peerflix.uid = config.ids.uids.peerflix;
  };
}
