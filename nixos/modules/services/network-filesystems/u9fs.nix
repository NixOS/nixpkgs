{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.u9fs;
in
{

  options = {

    services.u9fs = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the u9fs 9P server for Unix.";
      };

      listenStreams = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "564" ];
        example = [ "192.168.16.1:564" ];
        description = ''
          Sockets to listen for clients on.
          See {command}`man 5 systemd.socket` for socket syntax.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "nobody";
        description = "User to run u9fs under.";
      };

      extraArgs = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "-a none";
        description = ''
          Extra arguments to pass on invocation,
          see {command}`man 4 u9fs`
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    systemd = {
      sockets.u9fs = {
        description = "U9fs Listening Socket";
        wantedBy = [ "sockets.target" ];
        after = [ "network.target" ];
        inherit (cfg) listenStreams;
        socketConfig.Accept = "yes";
      };
      services."u9fs@" = {
        description = "9P Protocol Server";
        reloadIfChanged = true;
        requires = [ "u9fs.socket" ];
        serviceConfig = {
          ExecStart = "-${pkgs.u9fs}/bin/u9fs ${cfg.extraArgs}";
          StandardInput = "socket";
          StandardError = "journal";
          User = cfg.user;
          AmbientCapabilities = "cap_setuid cap_setgid";
        };
      };
    };

  };

}
