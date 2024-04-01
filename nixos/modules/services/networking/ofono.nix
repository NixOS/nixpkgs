# Ofono daemon.
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.ofono;

  plugin_path =
    lib.concatMapStringsSep ":"
      (plugin: "${plugin}/lib/ofono/plugins")
      cfg.plugins
    ;

in

{
  ###### interface
  options = {
    services.ofono = {
      enable = mkEnableOption "Ofono";

      plugins = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "[ pkgs.modem-manager-gui ]";
        description = lib.mdDoc ''
          The list of plugins to install.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.ofono ];

    systemd.packages = [ pkgs.ofono ];

    systemd.services.ofono.environment.OFONO_PLUGIN_PATH = mkIf (cfg.plugins != []) plugin_path;

  };
}
