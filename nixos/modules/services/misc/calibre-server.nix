{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.calibre-server;

in

{
  imports = [
    (mkChangedOptionModule [ "services" "calibre-server" "libraryDir" ] [ "services" "calibre-server" "libraries" ]
      (config:
        let libraryDir = getAttrFromPath [ "services" "calibre-server" "libraryDir" ] config;
        in [ libraryDir ]
      )
    )
  ];

  ###### interface

  options = {
    services.calibre-server = {

      enable = mkEnableOption (lib.mdDoc "calibre-server");

      libraries = mkOption {
        description = lib.mdDoc ''
          The directories of the libraries to serve. They must be readable for the user under which the server runs.
        '';
        type = types.listOf types.path;
      };

      user = mkOption {
        description = lib.mdDoc "The user under which calibre-server runs.";
        type = types.str;
        default = "calibre-server";
      };

      group = mkOption {
        description = lib.mdDoc "The group under which calibre-server runs.";
        type = types.str;
        default = "calibre-server";
      };
      
      listenAddress = mkOption {
        default = "::";
        example = "127.0.0.1";
        description = lib.mdDoc ''
          The interface on which to listen for connections. The value "::" will
          listen on all available IPv4 and IPv6 addresses.
        '';
        type = types.str;
      };

      port = mkOption {
        default = 8080;
        description = lib.mdDoc ''
          The port the Calibre server should listen on.
        '';
        type = types.int;
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.calibre-server = {
        description = "Calibre Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          Restart = "always";
          ExecStart = "${pkgs.calibre}/bin/calibre-server --listen-on ${cfg.listenAddress} --port ${toString cfg.port} ${lib.concatStringsSep " " cfg.libraries}";
        };
      };

    environment.systemPackages = [ pkgs.calibre ];

    users.users = optionalAttrs (cfg.user == "calibre-server") {
      calibre-server = {
        home = "/var/lib/calibre-server";
        createHome = true;
        uid = config.ids.uids.calibre-server;
        group = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "calibre-server") {
      calibre-server = {
        gid = config.ids.gids.calibre-server;
      };
    };

  };
}
