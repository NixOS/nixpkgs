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
      # typos: ignore: "certficate" instead of "certificate" (nested within submodule)
      # typos: ignore-next-line
      ssl.certficate = "/path/to/cert";
    };
  };
}
