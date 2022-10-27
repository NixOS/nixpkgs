{ config, lib, name, ... }:

with lib;
{
  options = {
    dataPath = mkOption {
      type = types.path;
      default = "/var/lib/pantalaimon-${name}";
      description = lib.mdDoc ''
        The directory where `pantalaimon` should store its state such as the database file.
      '';
    };

    logLevel = mkOption {
      type = types.enum [ "info" "warning" "error" "debug" ];
      default = "warning";
      description = lib.mdDoc ''
        Set the log level of the daemon.
      '';
    };

    homeserver = mkOption {
      type = types.str;
      example = "https://matrix.org";
      description = lib.mdDoc ''
        The URI of the homeserver that the `pantalaimon` proxy should
        forward requests to, without the matrix API path but including
        the http(s) schema.
      '';
    };

    ssl = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether or not SSL verification should be enabled for outgoing
        connections to the homeserver.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc ''
        The address where the daemon will listen to client connections
        for this homeserver.
      '';
    };

    listenPort = mkOption {
      type = types.port;
      default = 8009;
      description = lib.mdDoc ''
        The port where the daemon will listen to client connections for
        this homeserver. Note that the listen address/port combination
        needs to be unique between different homeservers.
      '';
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = lib.mdDoc ''
        Extra configuration options. See
        [pantalaimon(5)](https://github.com/matrix-org/pantalaimon/blob/master/docs/man/pantalaimon.5.md)
        for available options.
      '';
    };
  };
}
