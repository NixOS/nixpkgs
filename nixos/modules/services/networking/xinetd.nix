{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xinetd;

  inherit (pkgs) xinetd;

  configFile = pkgs.writeText "xinetd.conf"
    ''
      defaults
      {
        log_type       = SYSLOG daemon info
        log_on_failure = HOST
        log_on_success = PID HOST DURATION EXIT
        ${cfg.extraDefaults}
      }

      ${concatMapStrings makeService cfg.services}
    '';

  makeService = srv:
    ''
      service ${srv.name}
      {
        protocol    = ${srv.protocol}
        ${optionalString srv.unlisted "type        = UNLISTED"}
        ${optionalString (srv.flags != "") "flags = ${srv.flags}"}
        socket_type = ${if srv.protocol == "udp" then "dgram" else "stream"}
        ${if srv.port != 0 then "port        = ${toString srv.port}" else ""}
        wait        = ${if srv.protocol == "udp" then "yes" else "no"}
        user        = ${srv.user}
        server      = ${srv.server}
        ${optionalString (srv.serverArgs != "") "server_args = ${srv.serverArgs}"}
        ${srv.extraConfig}
      }
    '';

in

{

  ###### interface

  options = {

    services.xinetd.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the xinetd super-server daemon.
      '';
    };

    services.xinetd.extraDefaults = mkOption {
      default = "";
      type = types.string;
      description = ''
        Additional configuration lines added to the default section of xinetd's configuration.
      '';
    };

    services.xinetd.services = mkOption {
      default = [];
      description = ''
        A list of services provided by xinetd.
      '';

      type = types.listOf types.optionSet;

      options = {

        name = mkOption {
          type = types.string;
          example = "login";
          description = "Name of the service.";
        };

        protocol = mkOption {
          type = types.string;
          default = "tcp";
          description =
            "Protocol of the service.  Usually <literal>tcp</literal> or <literal>udp</literal>.";
        };

        port = mkOption {
          type = types.int;
          default = 0;
          example = 123;
          description = "Port number of the service.";
        };

        user = mkOption {
          type = types.string;
          default = "nobody";
          description = "User account for the service";
        };

        server = mkOption {
          type = types.string;
          example = "/foo/bin/ftpd";
          description = "Path of the program that implements the service.";
        };

        serverArgs = mkOption {
          type = types.string;
          default = "";
          description = "Command-line arguments for the server program.";
        };

        flags = mkOption {
          type = types.string;
          default = "";
          description = "";
        };

        unlisted = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether this server is listed in
            <filename>/etc/services</filename>.  If so, the port
            number can be omitted.
          '';
        };

        extraConfig = mkOption {
          type = types.string;
          default = "";
          description = "Extra configuration-lines added to the section of the service.";
        };

      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    jobs.xinetd =
      { description = "xinetd server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        path = [ xinetd ];

        exec = "xinetd -syslog daemon -dontfork -stayalive -f ${configFile}";
      };

  };

}
