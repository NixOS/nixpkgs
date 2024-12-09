{ config, lib, pkgs, ... }:
let
  inherit (pkgs) htpdate;

  cfg = config.services.htpdate;
in

{

  ###### interface

  options = {

    services.htpdate = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable htpdate daemon.
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Additional command line arguments to pass to htpdate.
        '';
      };

      servers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "www.google.com" ];
        description = ''
          HTTP servers to use for time synchronization.
        '';
      };

      proxy = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "127.0.0.1:8118";
        description = ''
          HTTP proxy used for requests.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.htpdate = {
      description = "htpdate daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/htpdate.pid";
        ExecStart = lib.concatStringsSep " " [
          "${htpdate}/bin/htpdate"
          "-D -u nobody"
          "-a -s"
          "-l"
          "${lib.optionalString (cfg.proxy != "") "-P ${cfg.proxy}"}"
          "${cfg.extraOptions}"
          "${lib.concatStringsSep " " cfg.servers}"
        ];
      };
    };

  };

}
