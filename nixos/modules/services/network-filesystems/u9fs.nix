{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.u9fs;
in
{

  options = {

    services.u9fs = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the u9fs 9P server for Unix.";
      };

      listenStreams = mkOption {
        type = types.listOf types.str;
        default = [ "564" ];
        example = [ "192.168.16.1:564" ];
        description = ''
          Sockets to listen for clients on.
          See <command>man 5 systemd.socket</command> for socket syntax.
        '';
      };

      extraArgs = mkOption {
        type = types.str;
        default = "";
        example = "-a none -u nobody";
        description =
          ''
            Extra arguments to pass on invocation,
            see <command>man 4 u9fs</command>
          '';
      };

      fsroot = mkOption {
        type = types.path;
        default = "/";
        example = "/srv";
        description = "File system root to serve to clients.";
      };

    };

  };

  config = mkIf cfg.enable {

    systemd = {
      sockets.u9fs = {
        description = "U9fs Listening Socket";
        wantedBy = [ "sockets.target" ];
        inherit (cfg) listenStreams;
        socketConfig.Accept = "yes";
      };
      services."u9fs@" = {
        description = "9P Protocol Server";
        reloadIfChanged = true;
        requires = [ "u9fs.socket" ];
        serviceConfig =
          { ExecStart = "-${pkgs.u9fs}/bin/u9fs ${cfg.extraArgs} ${cfg.fsroot}";
            StandardInput = "socket";
            StandardError = "journal";
          };
      };
    };

  };

}
