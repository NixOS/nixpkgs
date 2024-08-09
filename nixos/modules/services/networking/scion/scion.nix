{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.scion;
in
{
  options.services.scion = {
    enable = mkEnableOption "all of the scion components and services";
    package = mkPackageOption pkgs "scion" { };
    stateless = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Setting this value to false (stateful) can lead to improved caching and
        performance.

        This option decides whether to persist the SCION path sqlite databases
        on disk or not. Persisting this data can lead to database corruption in
        extreme cases such as power outage, meaning SCION fails to work on the
        next boot. This is being investigated.

        If true, /run/scion-* is used for data
        If false, use /var/lib/scion-* is used for data
      '';
    };
    bypassBootstrapWarning = mkOption {
      type = types.bool;
      default = false;
      description = ''
        bypass Nix warning about SCION PKI bootstrapping
      '';
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
    services.scion = {
      scion-dispatcher.enable = true;
      scion-daemon.enable = true;
      scion-router.enable = true;
      scion-control.enable = true;
    };
    assertions = [
      { assertion = cfg.bypassBootstrapWarning == true;
        message = ''
          SCION is a routing protocol and requires bootstrapping with a manual, imperative key signing ceremony. You may want to join an existing Isolation Domain (ISD) such as scionlab.org, or bootstrap your own. If you have completed and configured the public key infrastructure for SCION and are sure this process is complete, then add the following to your configuration:

          services.scion.bypassBootstrapWarning = true;

          refer to docs.scion.org for more information
        '';
      }
    ];
  };
}

