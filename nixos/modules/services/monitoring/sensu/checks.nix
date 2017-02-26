{ lib }:

{
  options = with lib; with types; {
    type = mkOption {
      type = enum [ "standard" "metric" ];
      default = "standard";
      description = "Type of check.";
    };

    standalone = mkOption {
      type = bool;
      default = false;
      description = "Scheduled by the client instead of the server.";
    };

    command = mkOption {
      type = str;
      description = "Command to run.";
    };

    subscribers = mkOption {
      type = listOf str;
      default = [];
      description = "Subscribers";
    };

    handlers = mkOption {
      default = [];
      description = "Handlers.";
      type = listOf str;
    };

    interval = mkOption {
      type = int;
      default = 60;
      description = "Check interval.";
    };

    timeout = mkOption {
      type = int;
      default = 30;
      description = "Check timeout.";
    };

    ttl = mkOption {
      type = int;
      default = 120;
      description = "Check TTL.";
    };

    source = mkOption {
      type = str;
      default = "";
      description = "Custom source for JIT checks.";
    };

    vars = mkOption {
      type = attrs;
      default = {};
      description = "Custom variables sent with the check.";
    };
  };
}
