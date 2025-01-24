{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.peerflix;
  opt = options.services.peerflix;

  configFile = pkgs.writeText "peerflix-config.json" ''
    {
      "connections": 50,
      "tmp": "${cfg.downloadDir}"
    }
  '';

in
{

  ###### interface

  options.services.peerflix = {
    enable = lib.mkOption {
      description = "Whether to enable peerflix service.";
      default = false;
      type = lib.types.bool;
    };

    stateDir = lib.mkOption {
      description = "Peerflix state directory.";
      default = "/var/lib/peerflix";
      type = lib.types.path;
    };

    downloadDir = lib.mkOption {
      description = "Peerflix temporary download directory.";
      default = "${cfg.stateDir}/torrents";
      defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/torrents"'';
      type = lib.types.path;
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
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

    users.users.peerflix = {
      isSystemUser = true;
      group = "peerflix";
    };
    users.groups.peerflix = { };
  };
}
