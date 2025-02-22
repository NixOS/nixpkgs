{ config, lib, ... }:

let
  inherit (lib)
    literalExpression
    mkOption
    types
    ;
in
{
  options = {
    serverName = mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = ''
        Server name to be used for this virtual host. Defaults to attribute
        name in hosts.
      '';
      example = "example.org";
    };

    serverAliases = mkOption {
      type = types.listOf types.nonEmptyStr;
      default = [ ];
      example = [
        "www.example.org"
        "example.org"
      ];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    http = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            port = mkOption {
              type = types.port;
              default = config.services.h2o.defaultHTTPListenPort;
              defaultText = literalExpression ''
                config.services.h2o.defaultHTTPListenPort
              '';
              description = ''
                Override the default HTTP port for this virtual host.
              '';
              example = literalExpression "8080";
            };
          };
        }
      );
      default = null;
      description = "HTTP options for virtual host";
    };

    tls = mkOption {
      type = types.nullOr (
        types.submodule {
          options = {
            port = mkOption {
              type = types.port;
              default = config.services.h2o.defaultTLSListenPort;
              defaultText = literalExpression ''
                config.services.h2o.defaultTLSListenPort
              '';
              description = ''
                Override the default TLS port for this virtual host.";
              '';
              example = 8443;
            };
            policy = mkOption {
              type = types.enum [
                "add"
                "only"
                "force"
              ];
              description = ''
                `add` will additionally listen for TLS connections. `only` will
                disable   TLS connections. `force` will redirect non-TLS traffic
                to the TLS connection.
              '';
              example = "force";
            };
            redirectCode = mkOption {
              type = types.ints.between 300 399;
              default = 301;
              example = 308;
              description = ''
                HTTP status used by `globalRedirect` & `forceSSL`. Possible
                usecases include temporary (302, 307) redirects, keeping the
                request method & body (307, 308), or explicitly resetting the
                method to GET (303). See
                <https://developer.mozilla.org/en-US/docs/Web/HTTP/Redirections>.
              '';
            };
            identity = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    key-file = mkOption {
                      type = types.path;
                      description = "Path to key file";
                    };
                    certificate-file = mkOption {
                      type = types.path;
                      description = "Path to certificate file";
                    };
                  };
                }
              );
              default = null;
              description = ''
                Key / certificate pairs for the virtual host.
              '';
              example =
                literalExpression
                  # nix
                  ''
                    [
                      {
                        key-file = "/path/to/rsa.key";
                        certificate-file = "/path/to/rsa.crt";
                      }
                      {
                        key-file = "/path/to/ecdsa.key";
                        certificate-file = "/path/to/ecdsa.crt";
                      }
                    ]
                  '';
            };
            extraSettings = mkOption {
              type = types.nullOr types.attrs;
              default = null;
              description = ''
                Additional TLS/SSL-related configuration options.
              '';
              example =
                literalExpression
                  # nix
                  ''
                    {
                      minimum-version = "TLSv1.3";
                    }
                  '';
            };
          };
        }
      );
      default = null;
      description = "TLS options for virtual host";
    };

    settings = mkOption {
      type = types.attrs;
      description = ''
        Attrset to be transformed into YAML for host config. Note that the HTTP
        / TLS configurations will override these config values.
      '';
    };
  };
}
