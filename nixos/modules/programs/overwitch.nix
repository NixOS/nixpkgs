{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.programs.overwitch;

  overwitch = cfg.package.override {
    withGui = cfg.gui.enable;
  };
in {
  options.programs.overwitch = {
    enable = mkEnableOption (lib.mdDoc "Install overwitch and add the necessary udev and hwdb rules.");

    package = mkOption {
      type = types.package;
      default = pkgs.overwitch;
      defaultText = "pkgs.overwitch";
      description = "Set version of overwitch package to use.";
    };

    gui.enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether to enable the overwitch GUI application.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ overwitch  ];
    services.udev.packages = [ overwitch ];
  };

  meta.maintainers = with lib.maintainers; [ dag-h ];
}
