{ lib, ... }:
{
  options = {
    host = lib.mkOption {
      type = lib.types.str;
      example = "127.0.0.1";
      description = ''
        Server host address.
      '';
    };
    port = lib.mkOption {
      type = lib.types.int;
      example = 5088;
      description = ''
        Server host port.
      '';
    };
  };
}
