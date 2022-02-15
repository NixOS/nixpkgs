{ pkgs, lib, config, ... }:

with lib;

let cfg = config.services.input-remapper; in
{
  options = {
    services.input-remapper = {
      enable = mkEnableOption "input-remapper, an easy to use tool to change the mapping of your input device buttons.";
      package = mkOption {
        type = types.package;
        default = pkgs.input-remapper;
        defaultText = literalExpression "pkgs.input-remapper";
        description = ''
          The input-remapper package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # FIXME: udev rule hangs sometimes when lots of devices connected, so let's not use it
    # config.services.udev.packages = mapper-pkg;
    services.dbus.packages = cfg.package;
    systemd.packages = cfg.package;
    environment.systemPackages = cfg.package;
    systemd.services.input-remapper.wantedBy = [ "graphical.target" ];
  };
}
