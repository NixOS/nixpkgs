{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xinetd;

  configFile = pkgs.writeText "xinetd.conf"
    ''
      defaults
      {
        log_type       = SYSLOG daemon info
        log_on_failure = HOST
        log_on_success = PID HOST DURATION EXIT
        ${cfg.extraDefaults}
      }

      ${concatMapStrings makeInternalService cfg.internalServices}
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

  internalServices = {
    echo = ''
# description: An xinetd internal service which echo's characters back to
# clients.
# This is the tcp version.
service echo
{
	disable		= no
	type		= INTERNAL
	id		= echo-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}
# This is the udp version.
service echo
{
	disable		= no
	type		= INTERNAL
	id		= echo-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
    '';
    chargen = ''
# description: An xinetd internal service which generate characters.  The
# xinetd internal service which continuously generates characters until the
# connection is dropped.  The characters look something like this:
# !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefg
# This is the tcp version.
service chargen
{
	disable		= no
	type		= INTERNAL
	id		= chargen-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}

# This is the udp version.
service chargen
{
	disable		= no
	type		= INTERNAL
	id		= chargen-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
    '';
    discard = ''
# description: An RFC 863 discard server.
# This is the tcp version.
service discard
{
	disable		= no
	type		= INTERNAL
	id		= discard-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}

# This is the udp version.
service discard
{
	disable		= no
	type		= INTERNAL
	id		= discard-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
    '';
    daytime = ''
# description: An internal xinetd service which gets the current system time
# then prints it out in a format like this: "Wed Nov 13 22:30:27 EST 2002".
# This is the tcp version.
service daytime
{
	disable		= no
	type		= INTERNAL
	id		= daytime-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}

# This is the udp version.
service daytime
{
	disable		= no
	type		= INTERNAL
	id		= daytime-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
    '';
    time = ''
# description: An RFC 868 time server. This protocol provides a
# site-independent, machine readable date and time. The Time service sends back
# to the originating source the time in seconds since midnight on January first
# 1900.
# This is the tcp version.
service time
{
	disable		= no
	type		= INTERNAL
	id		= time-stream
	socket_type	= stream
	protocol	= tcp
	user		= root
	wait		= no
}

# This is the udp version.
service time
{
	disable		= no
	type		= INTERNAL
	id		= time-dgram
	socket_type	= dgram
	protocol	= udp
	user		= root
	wait		= yes
}
    '';
      };

  makeInternalService = srv: internalServices.${srv} ;

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

    services.xinetd.internalServices = mkOption {
      default = [];
      description = ''
        A list of internal services provided by xinetd. Example:
        ["echo" "chargen" "discard" "daytime" "time"]
      '';

      type = with types; listOf str;
    };

    services.xinetd.services = mkOption {
      default = [];
      description = ''
        A list of services provided by xinetd.
      '';

      type = with types; listOf (submodule ({

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
            type = types.lines;
            default = "";
            description = "Extra configuration-lines added to the section of the service.";
          };

        };

      }));

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.xinetd = {
      description = "xinetd server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.xinetd ];
      script = "xinetd -syslog daemon -dontfork -stayalive -f ${configFile}";
    };
  };
}
