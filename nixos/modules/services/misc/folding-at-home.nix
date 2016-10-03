{ config, lib, pkgs, ... }:
with lib;
let
  stateDir = "/var/lib/foldingathome";
  cfg = config.services.foldingAtHome;
  fahUser = "foldingathome";
in {

  ###### interface

  options = {

    services.foldingAtHome = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the Folding@Home to use idle CPU time.
        '';
      };

      nickname = mkOption {
        default = "Anonymous";
        description = ''
          A unique handle for statistics.
        '';
      };

      config = mkOption {
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to the
          configuration file.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = fahUser;
        uid = config.ids.uids.foldingathome;
        description = "Folding@Home user";
        home = stateDir;
      };

    systemd.services.foldingathome = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
        chown ${fahUser} ${stateDir}
        cp -f ${pkgs.writeText "client.cfg" cfg.config} ${stateDir}/client.cfg
      '';
      script = "${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${fahUser} -c 'cd ${stateDir}; ${pkgs.foldingathome}/bin/fah6'";
    };

    services.foldingAtHome.config = ''
        [settings]
        username=${cfg.nickname}
    '';
  };
}
