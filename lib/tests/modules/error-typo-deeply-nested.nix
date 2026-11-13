{ lib, ... }:

{
  options.services = {
    nginx = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      virtualHosts = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enableSSL = lib.mkOption {
                default = false;
                type = lib.types.bool;
              };
              ssl = {
                certificate = lib.mkOption {
                  default = "";
                  type = lib.types.str;
                };
                certificateKey = lib.mkOption {
                  default = "";
                  type = lib.types.str;
                };
              };
            };
          }
        );
        default = { };
      };
    };
  };

  config = {
    services.nginx.virtualHosts."example.com" = {
      # Typo: "certficate" instead of "certificate" (nested within submodule)
      ssl.certficate = "/path/to/cert";
    };
  };
}
