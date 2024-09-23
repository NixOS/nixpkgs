{ config, lib, pkgs, ... }:
let

  cfg = config.services.lambdabot;

  rc = builtins.toFile "script.rc" cfg.script;

in

{

  ### configuration

  options = {

    services.lambdabot = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Lambdabot IRC bot";
      };

      package = lib.mkPackageOption pkgs "lambdabot" { };

      script = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Lambdabot script";
      };

    };

  };

  ### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.lambdabot = {
      description = "Lambdabot daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # Workaround for https://github.com/lambdabot/lambdabot/issues/117
      script = ''
        mkdir -p ~/.lambdabot
        cd ~/.lambdabot
        mkfifo /run/lambdabot/offline
        (
          echo 'rc ${rc}'
          while true; do
            cat /run/lambdabot/offline
          done
        ) | ${cfg.package}/bin/lambdabot
      '';
      serviceConfig = {
        User = "lambdabot";
        RuntimeDirectory = [ "lambdabot" ];
      };
    };

    users.users.lambdabot = {
      group = "lambdabot";
      description = "Lambdabot daemon user";
      home = "/var/lib/lambdabot";
      createHome = true;
      uid = config.ids.uids.lambdabot;
    };

    users.groups.lambdabot.gid = config.ids.gids.lambdabot;

  };

}
