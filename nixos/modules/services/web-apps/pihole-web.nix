{
  config,
  lib,
  pkgs,
  ...
}:

with { inherit (lib) mkOption types; };

let
  cfg = config.services.pihole-web;
in
{
  options.services.pihole-web = {
    enable = lib.mkEnableOption "Pi-hole dashboard";

    package = lib.mkPackageOption pkgs "pihole-web" { };

    hostName = mkOption {
      type = types.str;
      description = "Domain name for the website.";
      default = "pi.hole";
    };

    ports =
      let
        portType = types.submodule {
          options = {
            port = mkOption {
              type = types.port;
              description = "Port to bind";
            };
            optional = mkOption {
              type = types.bool;
              default = false;
              description = "Skip the port if it cannot be bound";
            };
            redirectSSL = mkOption {
              type = types.bool;
              default = false;
              description = "Redirect from this port to the first configured SSL port";
            };
            ssl = mkOption {
              type = types.bool;
              default = false;
              description = "Serve SSL on the port";
            };
          };
        };
      in
      mkOption {
        type = types.listOf (
          types.oneOf [
            types.port
            types.str
            portType
          ]
        );
        description = ''
          Port(s) for the webserver to serve on.

          If provided as a string, optionally append suffixes to control behaviour:

          - `o`: to make the port is optional - failure to bind will not be an error.
          - `s`: for the port to be used for SSL.
          - `r`: for a non-SSL port to redirect to the first available SSL port.
        '';
        example = [
          "80r"
          "443s"
        ];
        apply =
          values:
          let
            convert =
              value:
              if (builtins.typeOf) value == "int" then
                toString value
              else if builtins.typeOf value == "set" then
                lib.strings.concatStrings [
                  (toString value.port)
                  (lib.optionalString value.optional "o")
                  (lib.optionalString value.redirectSSL "r")
                  (lib.optionalString value.ssl "s")
                ]
              else
                value;
          in
          lib.strings.concatStringsSep "," (map convert values);
      };
  };

  config = lib.mkIf cfg.enable {
    services.pihole-ftl.settings.webserver = {
      domain = cfg.hostName;
      port = cfg.ports;
      paths.webroot = "${cfg.package}/share/";
      paths.webhome = "/";
    };
  };

  meta = {
    doc = ./pihole-web.md;
    maintainers = with lib.maintainers; [ williamvds ];
  };
}
