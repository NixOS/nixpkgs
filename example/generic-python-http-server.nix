{ lib, config, options, pkgs, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.service;
in
{
  # I think `service` could be the place where the service itself is configured.
  # Alternatively, this could have been `pythonHttpServer`, but then over time
  # we'd endup with a service module namespace where we don't really know which
  # names will conflict, whenever we introduce a new generic top level option in
  # the future.
  options.service = {
    port = lib.mkOption {
      type = types.int;
      default = 8080;
      description = ''
        Port number where the web server should listen.
      '';
    };
    directory = lib.mkOption {
      type = types.path;
      description = ''
        A path to serve over HTTP.
      '';
    };
  };

  config = {
    # Obligatory relaying of: Warning http.server is not recommended for production. It only implements basic security checks.
    process = "${pkgs.python3}/bin/python3";
    args = [
      "-m" "http.server" (toString cfg.port)
      "--directory" cfg.directory
    ];
  };
}