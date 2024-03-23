{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.nut;
in
{
  port = 9199;
  extraOpts = {
    nutServer = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        Hostname or address of the NUT server
      '';
    };
    nutUser = mkOption {
      type = types.str;
      default = "";
      example = "nut";
      description = lib.mdDoc ''
        The user to log in into NUT server. If set, passwordPath should
        also be set.

        Default NUT configs usually permit reading variables without
        authentication.
      '';
    };
    passwordPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      apply = final: if final == null then null else toString final;
      description = lib.mdDoc ''
        A run-time path to the nutUser password file, which should be
        provisioned outside of Nix store.
      '';
    };
    nutVariables = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of NUT variable names to monitor.

        If no variables are set, all numeric variables will be exported automatically.
        See the [upstream docs](https://github.com/DRuggeri/nut_exporter?tab=readme-ov-file#variables-and-information)
        for more information.
      '';
    };
  };
  serviceOpts = {
    script = ''
      ${optionalString (cfg.passwordPath != null)
      "export NUT_EXPORTER_PASSWORD=$(cat ${toString cfg.passwordPath})"}
      ${pkgs.prometheus-nut-exporter}/bin/nut_exporter \
        --nut.server=${cfg.nutServer} \
        --web.listen-address="${cfg.listenAddress}:${toString cfg.port}" \
        ${optionalString (cfg.nutUser != "") "--nut.username=${cfg.nutUser}"} \
        ${optionalString (cfg.nutVariables != []) "--nut.vars_enable=${concatStringsSep "," cfg.nutVariables}"} \
        ${concatStringsSep " " cfg.extraFlags}
    '';
  };
}
