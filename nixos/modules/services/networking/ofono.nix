# Ofono daemon.
{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.ofono;

  plugin_path = lib.concatMapStringsSep ":" (plugin: "${plugin}/lib/ofono/plugins") cfg.plugins;

in

{
  ###### interface
  options = {
    services.ofono = {
      enable = lib.mkEnableOption "Ofono";

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.modem-manager-gui ]";
        description = ''
          The list of plugins to install.
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ pkgs.ofono ];

    systemd.packages = [ pkgs.ofono ];

    systemd.services.ofono.environment.OFONO_PLUGIN_PATH = lib.mkIf (cfg.plugins != [ ]) plugin_path;

  };
}
