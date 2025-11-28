{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.tiddlywiki;
  listenParams = lib.concatStrings (
    lib.mapAttrsToList (n: v: " '${n}=${toString v}' ") cfg.listenOptions
  );
  exe = "${pkgs.nodePackages.tiddlywiki}/bin/tiddlywiki";
  name = "tiddlywiki";
  dataDir = "/var/lib/" + name;

in
{

  options.services.tiddlywiki = {

    enable = lib.mkEnableOption "TiddlyWiki nodejs server";

    listenOptions = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        credentials = "../credentials.csv";
        readers = "(authenticated)";
        port = 3456;
      };
      description = ''
        Parameters passed to `--listen` command.
        Refer to <https://tiddlywiki.com/#WebServer>
        for details on supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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
