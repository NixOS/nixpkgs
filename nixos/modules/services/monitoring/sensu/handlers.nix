{ lib }:

{
  options = with lib; with types; {
    type = mkOption {
      description = "Type of handler.";
      type = enum [ "pipe" "tcp" "udp" "transport" "set" ];
    };

    filters = mkOption {
      default = [];
      description = "List of filters.";
      type = listOf str;
    };

    severities = mkOption rec {
      default = [ "critical" "warning" "unknown" ];
      description = "Severities to handle.";
      type = listOf (enum (default ++ [ "ok" ]));
    };

    subscribers = mkOption {
      default = [];
      description = "Subscribers";
      type = listOf str;
    };

    timeout = mkOption {
      default = 30;
      description = "Timeout.";
      type = int;
    };

    command = mkOption {
      default = "";
      description = "Command for type pipe.";
      type = str;
    };

    socket = mkOption {
      default = {};
      description = "Socket for type tcp or udp.";
      type = attrs;
    };

    pipe = mkOption {
      default = {};
      description = "Pipe for type pipe.";
      type = attrs;
    };

    mutator = mkOption {
      default = "";
      description = "Mutator.";
      type = str;
    };

    handlers = mkOption {
      default = [];
      description = "Handlers for type set.";
      type = listOf str;
    };
  };
}
