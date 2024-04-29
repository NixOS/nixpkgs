{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.tiddlywiki;
  listenParams = concatStrings (mapAttrsToList (n: v: " '${n}=${toString v}' ") cfg.listenOptions);
  exe = "${pkgs.nodePackages.tiddlywiki}/lib/node_modules/.bin/tiddlywiki";
  name = "tiddlywiki";
  dataDir = "/var/lib/" + name;

in {

  options.services.tiddlywiki = {

    enable = mkEnableOption "TiddlyWiki nodejs server";

    listenOptions = mkOption {
      type = types.attrs;
      default = {};
      example = {
        credentials = "../credentials.csv";
        readers="(authenticated)";
        port = 3456;
      };
      description = ''
        Parameters passed to `--listen` command.
        Refer to <https://tiddlywiki.com/#WebServer>
        for details on supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services.tiddlywiki = {
        description = "TiddlyWiki nodejs server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          DynamicUser = true;
          StateDirectory = name;
          ExecStartPre = "-${exe} ${dataDir} --init server";
          ExecStart = "${exe} ${dataDir} --listen ${listenParams}";
        };
      };
    };
  };
}
