{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.mouse-actions;
in
{
  options.programs.mouse-actions = {
    enable = lib.mkEnableOption "" // {
      description = ''
        Whether to install and set up mouse-actions and it's udev rules.

        Note that only users in the "uinput" group will be able to use the package
      '';
    };
    package = lib.mkPackageOption pkgs "mouse-actions" {
      example = "mouse-actions-gui";
    };
    autorun = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to start a user service to run mouse-actions on startup.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    systemd.user.services.mouse-actions = lib.mkIf cfg.autorun {
      description = "mouse-actions launcher";
      wantedBy = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      environment.PATH = lib.mkForce null; # don't use the default PATH provided by NixOS
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} start";
        PassEnvironment = "PATH"; # inherit PATH from user environment
      };
    };
  };
}
