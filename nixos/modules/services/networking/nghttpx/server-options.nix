{ lib, ... }:
{ options = {
    host = lib.mkOption {
      type        = lib.types.str;
      example     = "127.0.0.1";
      description = lib.mdDoc ''
        Server host address.
      '';
    };
    port = lib.mkOption {
      type        = lib.types.int;
      example     = 5088;
      description = lib.mdDoc ''
        Server host port.
      '';
    };
  };
}
