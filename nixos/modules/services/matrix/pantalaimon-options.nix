{
  config,
  lib,
  name,
  ...
}:

with lib;
{
  options = {
    dataPath = mkOption {
      type = types.path;
      default = "/var/lib/pantalaimon-${name}";
      description = ''
        The directory where `pantalaimon` should store its state such as the database file.
      '';
    };

    logLevel = mkOption {
      type = types.enum [
        "info"
        "warning"
        "error"
        "debug"
      ];
      default = "warning";
      description = ''
        Set the log level of the daemon.
      '';
    };

    homeserver = mkOption {
      type = types.str;
      example = "https://matrix.org";
      description = ''
        The URI of the homeserver that the `pantalaimon` proxy should
        forward requests to, without the matrix API path but including
        the http(s) schema.
      '';
    };

    ssl = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not SSL verification should be enabled for outgoing
        connections to the homeserver.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        The address where the daemon will listen to client connections
        for this homeserver.
      '';
    };

    listenPort = mkOption {
      type = types.port;
      default = 8009;
      description = ''
        The port where the daemon will listen to client connections for
        this homeserver. Note that the listen address/port combination
        needs to be unique between different homeservers.
      '';
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Extra configuration options. See
        [pantalaimon(5)](https://github.com/matrix-org/pantalaimon/blob/master/docs/man/pantalaimon.5.md)
        for available options.
      '';
    };
  };
}
