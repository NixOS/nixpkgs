# Non-module dependencies (`importApply`)
{ pkgs }:

# Service module
{
  lib,
  config,
  ...
}:
let
  cfg = config.autoendpoint;
  tomlFmt = pkgs.formats.toml { };
in
{
  _class = "service";
  options = {
    package = lib.mkPackageOption pkgs "autopush-rs.out" { };
    autoendpoint = {
      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = tomlFmt.type;
          options = {
            db_dsn = lib.mkOption {
              description = "Endpoint of the database server.";
              type = lib.types.str;
              default = "";
              example = lib.literalExpression "redis+socket://\${config.services.redis.servers.autopush-rs.port}";
            };
          };
        };
        default = { };
        description = "";
      };
    };
  };
  config =
    let
      configFile = tomlFmt.generate "autoendpoint.toml" cfg.settings;
    in
    {
      process.argv = [
        "${config.package}/bin/autoendpoint"
        "-c"
        (toString configFile)
      ];
    };
}
