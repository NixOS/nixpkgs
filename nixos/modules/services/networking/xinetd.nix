{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.xinetd;

  configFile = pkgs.writeText "xinetd.conf" ''
    defaults
    {
      log_type       = SYSLOG daemon info
      log_on_failure = HOST
      log_on_success = PID HOST DURATION EXIT
      ${cfg.extraDefaults}
    }

    ${lib.concatMapStrings makeService cfg.services}
  '';

  makeService = srv: ''
    service ${srv.name}
    {
      protocol    = ${srv.protocol}
      ${lib.optionalString srv.unlisted "type        = UNLISTED"}
      ${lib.optionalString (srv.flags != "") "flags = ${srv.flags}"}
      socket_type = ${if srv.protocol == "udp" then "dgram" else "stream"}
      ${lib.optionalString (srv.port != 0) "port        = ${toString srv.port}"}
      wait        = ${if srv.protocol == "udp" then "yes" else "no"}
      user        = ${srv.user}
      server      = ${srv.server}
      ${lib.optionalString (srv.serverArgs != "") "server_args = ${srv.serverArgs}"}
      ${srv.extraConfig}
    }
  '';

in

{

  ###### interface

  options = {

    services.xinetd.enable = lib.mkEnableOption "the xinetd super-server daemon";

    services.xinetd.extraDefaults = lib.mkOption {
      default = "";
      type = lib.types.lines;
      description = ''
        Additional configuration lines added to the default section of xinetd's configuration.
      '';
    };

    services.xinetd.services = lib.mkOption {
      default = [ ];
      description = ''
        A list of services provided by xinetd.
      '';

      type =
        lib.types.listOf (lib.types.submodule ({

          options = {

            name = lib.mkOption {
              type = lib.types.str;
              example = "login";
              description = "Name of the service.";
            };

            protocol = lib.mkOption {
              type = lib.types.str;
              default = "tcp";
              description = "Protocol of the service.  Usually `tcp` or `udp`.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 0;
              example = 123;
              description = "Port number of the service.";
            };

            user = lib.mkOption {
              type = lib.types.str;
              default = "nobody";
              description = "User account for the service";
            };

            server = lib.mkOption {
              type = lib.types.str;
              example = "/foo/bin/ftpd";
              description = "Path of the program that implements the service.";
            };

            serverArgs = lib.mkOption {
              type = lib.types.separatedString " ";
              default = "";
              description = "Command-line arguments for the server program.";
            };

            flags = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "";
            };

            unlisted = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether this server is listed in
                {file}`/etc/services`.  If so, the port
                number can be omitted.
              '';
            };

            extraConfig = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Extra configuration-lines added to the section of the service.";
            };

          };

        }));

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.xinetd = {
      description = "xinetd server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.xinetd ];
      script = "exec xinetd -syslog daemon -dontfork -stayalive -f ${configFile}";
    };
  };
}
