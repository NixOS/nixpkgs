{ lib, ... }:

{
  options.services = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
          port = lib.mkOption {
            default = 8080;
            type = lib.types.int;
          };
        };
      }
    );
    default = { };
  };

  config = {
    services.myservice = {
      # Typo: "prot" instead of "port"
      prot = 9000;
    };
  };
}
