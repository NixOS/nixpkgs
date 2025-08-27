# Tests in: ../../../../tests/modular-service-etc/test.nix

# Non-modular context provided by the modular services integration.
{ pkgs }:

# Configuration data support for portable services
# This module provides configData for services, enabling configuration reloading
# without terminating and restarting the service process.
{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (lib.modules) importApply;
in
{
  options = {
    configData = mkOption {
      default = { };
      example = lib.literalExpression ''
        {
          "server.conf" = {
            text = '''
              port = 8080
              workers = 4
            ''';
          };
          "ssl/cert.pem" = {
            source = ./cert.pem;
          };
        }
      '';
      description = ''
        Configuration data files for the service

        These files are made available to the service and can be updated without restarting the service process, enabling configuration reloading.
        The service manager implementation determines how these files are exposed to the service (e.g., via a specific directory path).
        This path is available in the `path` sub-option for each `configData.<name>` entry.

        This is particularly useful for services that support configuration reloading via signals (e.g., SIGHUP) or which pick up changes automatically, so that no downtime is required in order to reload the service.
      '';

      type = types.lazyAttrsOf (types.submodule (importApply ./config-data-item.nix pkgs));
    };
  };
}
