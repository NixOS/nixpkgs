{ config, lib, pkgs, ... }:
let
  cfg = config.services.firewalld;
in
{
  options.services.firewalld = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      Whether to enable DBus-enabled firewall daemon.

      ::: {.warning}
      Enabling this service WILL disable the existing NixOS
      firewall! Default firewall rules provided by packages are not
      considered at the moment.
      :::
    '');

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firewalld;
      defaultText = lib.literalExpression "pkgs.firewalld";
      description = lib.mdDoc "The firewalld package to use.";
    };

    config = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        DefaultZone = "drop";
      };
      description = lib.mdDoc ''
        Each attribute in this set specifies an option in firewalld.conf.

        If set to non-empty, the permanent configuration will be immutable and
        cannot be modified via firewalld. The runtime configuration remains mutable.

        Refer to [`firewalld.conf(5)`](https://firewalld.org/documentation/man-pages/firewalld.conf.html)
        for available configuration options.
      '';
    };
  };

  config = lib.mkIf (cfg.enable) {
    networking.firewall.enable = false;
    security.polkit.enable = lib.mkDefault true;

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    environment.etc."firewalld/firewalld.conf" = lib.mkIf (cfg.config != {}) {
      text = lib.generators.toKeyValue {} cfg.config;
    };

    systemd.services.firewalld = {
      aliases = [ "dbus-org.fedoraproject.FirewallD1.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
