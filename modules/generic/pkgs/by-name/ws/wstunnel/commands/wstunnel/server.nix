# Command line of `wstunnel server`, in a module that is not specific to a
# module class. The NixOS module `services.wstunnel` and
# `passthru.commandModules.wstunnel.commands.server` of `pkgs.wstunnel` use it.
# The options that all subcommands share are in `../wstunnel.nix`. See "Modules
# of a package" in the Nixpkgs manual for why it is in this directory.

{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkAfter
    mkMerge
    mkOption
    mkOrder
    types
    ;
  hostPortToString = { host, port, ... }: "${host}:${toString port}";
in
{
  imports = [ ../wstunnel.nix ];

  options = {
    listen = mkOption {
      description = ''
        Address and port to listen on.
        Setting the port to a value below 1024 will also give the process
        the required `CAP_NET_BIND_SERVICE` capability.
      '';
      type = types.submodule {
        options = {
          host = mkOption {
            description = "The hostname.";
            type = types.str;
          };
          port = mkOption {
            description = "The port.";
            type = types.port;
          };
          enableHTTPS = mkOption {
            description = "Use HTTPS for the tunnel server.";
            type = types.bool;
            default = true;
          };
        };
      };
      default =
        { config, ... }:
        {
          host = "0.0.0.0";
          port = if config.enableHTTPS then 443 else 80;
        };
      defaultText = lib.literalExpression ''
        { config, ... }:
        {
          host = "0.0.0.0";
          port = if config.enableHTTPS then 443 else 80;
        }
      '';
    };

    settings = mkOption {
      type = types.submodule {
        options = {
          restrict-to = mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  host = mkOption {
                    description = "The hostname.";
                    type = types.str;
                  };
                  port = mkOption {
                    description = "The port.";
                    type = types.port;
                  };
                };
              }
            );
            default = [ ];
            example = [
              {
                host = "127.0.0.1";
                port = 51820;
              }
            ];
            description = ''
              Restrictions on the connections that the server will accept.
              For more flexibility, and the possibility to also allow reverse tunnels,
              look into the `restrict-config` option that takes a path to a yaml file.
            '';
          };
        };
      };
    };
  };

  config.portable.argv = mkMerge [
    [ "server" ]
    # The flags of the subcommand come after it.
    (mkOrder 1250 (
      lib.cli.toCommandLine config.portable.flagFormat (
        config.settings
        // {
          restrict-to = map hostPortToString config.settings.restrict-to;
        }
      )
    ))
    (mkAfter [
      "${if config.listen.enableHTTPS then "wss" else "ws"}://${hostPortToString config.listen}"
    ])
  ];
}
