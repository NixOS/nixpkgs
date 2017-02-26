{ lib }:

{
  options = with lib; with types; {
    name = mkOption {
      type = str;
      default = "";
      description = "Name of the client.";
    };

    address = mkOption {
      type = str;
      default = "";
      description = "IP address";
    };

    subscriptions = mkOption {
      type = listOf str;
      default = [ ];
      description = "Subscriptions";
    };

    socket = mkOption {
      description = "The socket configuration.";
      default = {};
      type = submodule {
        options = {
          bind = mkOption {
            type = str;
            default = "127.0.0.1";
            description = "The IP address on which the client listens.";
          };

          port = mkOption {
            type = int;
            default = 3030;
            description = "The port on which the client listens.";
          };
        };
      };
    };

    vars = mkOption {
      type = attrs;
      default = {};
      description = "Custom attributes/variables.";
    };
  };
}
