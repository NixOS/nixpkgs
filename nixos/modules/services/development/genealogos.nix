{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.genealogos;
  rocketConfigFormat = pkgs.formats.toml { };
in
{
  options = {
    services.genealogos = {
      enable = mkEnableOption "Genealogos, a Nix sbom generator";

      package = mkOption {
        type = types.package;
        default = pkgs.genealogos-api;
        defaultText = literalExpression "pkgs.genealogos-api";
        description = ''
          The genealogos-api package to use.
        '';
      };

      rocketConfig = lib.mkOption {
        type = rocketConfigFormat.type;
        default = { };
        example = lib.literalExpression ''
          {
            release = {
              address = "0.0.0.0";
              port = "8000";
              limits = {
                form = "64 kB";
                json = "1 MiB";
              };
            };
          }
        '';

        description = ''
          Configuration file for Genealogos.

          Genealogos-api uses Rocket as its webserver implementation.
          For all rocket configuration options, see https://rocket.rs/guide/v0.5/configuration/#configuration-parameters

          Genealogos further defines some custom options.
          See the project's [README](https://github.com/tweag/genealogos/blob/master/README.md) for more information.
        '';
      };
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.genealogos = {
      description = "Genealogos sbom generator";
      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${cfg.package}/bin/genealogos-api";

      environment = {
        ROCKET_CONFIG = rocketConfigFormat.generate "Rocket.toml" cfg.rocketConfig;
      };
    };
  };
}
