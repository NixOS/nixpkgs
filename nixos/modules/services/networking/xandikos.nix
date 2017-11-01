{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xandikos;

in

{

  options = {
    services.xandikos.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
          Enable xandikos CalDAV and CardDAV server.
      '';
    };

    services.xandikos.directory = mkOption {
      type = types.string;
      default = "/var/lib/xandikos";
      description = ''
        Directory to serve from.
      '';
    };

    services.xandikos.autocreate = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Automatically create necessary directories.
      '';
    };

    services.xandikos.defaults = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create initial calendar and address bool.
        Implies <literal>autocreate</literal>.
      '';
    };

    services.xandikos.port = mkOption {
      type = types.int;
      default = 8080;
      description = ''
        Port to listen on.
      '';
    };

    services.xandikos.host = mkOption {
      type = types.string;
      default = "localhost";
      description = ''
        Binding IP address.
      '';
    };

    services.xandikos.routeprefix = mkOption {
      type = types.string;
      default = "/";
      description = ''
        Path to Xandikos.
        Useful when Xandikos is behind a reverse proxy.
      '';
    };

    services.xandikos.package = mkOption {
      type = types.package;
      default = pkgs.xandikos;
      description = ''
        Xandikos package to use.
      '';
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.extraUsers = singleton
      { name = "xandikos";
        uid = config.ids.uids.xandikos;
        description = "xandikosuser";
        home = "/var/lib/xandikos";
        createHome = true;
      };

    users.extraGroups = singleton
      { name = "xandikos";
        gid = config.ids.gids.xandikos;
      };

    systemd.services.xandikos = {
      description   = "A Simple Calendar and Contact Server";
      after         = [ "network.target" ];
      wantedBy      = [ "multi-user.target" ];
      serviceConfig = {
        User      = "xandikos";
        Group     = "xandikos";
        ExecStart =
          concatStringsSep " "
            ([
              "${cfg.package}/bin/xandikos"
              "--directory" cfg.directory
              "--autocreate" cfg.autocreate
            ]
            ++ (if cfg.defaults then "--defaults" else "")
            ++ [
              "--port" cfg.port
              "--listen_address" cfg.host
              "--route-prefix" cfg.routeprefix
            ]);
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ matthiasbeyer ];
}
