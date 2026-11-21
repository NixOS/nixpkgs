# Command line of `wstunnel client`, in a module that is not specific to a
# module class. The NixOS module `services.wstunnel` and
# `passthru.commandModules.wstunnel.commands.client` of `pkgs.wstunnel` use it.
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
in
{
  imports = [ ../wstunnel.nix ];

  options = {
    connectTo = mkOption {
      description = "Server address and port to connect to.";
      type = types.str;
      example = "https://wstunnel.server.com:8443";
    };

    settings = mkOption {
      type = types.submodule {
        options = {
          http-headers = mkOption {
            type = types.coercedTo (types.attrsOf types.str) (lib.mapAttrsToList (n: v: "${n}:${v}")) (
              types.listOf types.str
            );
            default = { };
            example = {
              "X-Some-Header" = "some-value";
            };
            description = ''
              Custom headers to send in the upgrade request
            '';
          };
        };
      };
    };
  };

  config.portable.argv = mkMerge [
    [ "client" ]
    # The flags of the subcommand come after it.
    (mkOrder 1250 (lib.cli.toCommandLine config.portable.flagFormat config.settings))
    (mkAfter [ config.connectTo ])
  ];
}
