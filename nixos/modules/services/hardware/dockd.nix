{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.dockd;
in
{
  ###############################################
  options.services.dockd = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, run dockd as a systemd user service.
      '';
    };

    dockedConfPath = mkOption {
      type = types.str;
      default = "/etc/dockd/docked.conf";
      description = ''
        Path to the file that will store the configuration of the
        environment when the ThinkPad is placed on the dock.
      '';
    };

    undockedConfPath = mkOption {
      type = types.str;
      default = "/etc/dockd/undocked.conf";
      description = ''
        Path to the file that will store the configuration of the
         environment when the ThinkPad is removed from the dock.
      '';
    };

    dockHookPath = mkOption {
      type = types.str;
      default = "/etc/dockd/dock.hook";
      description = ''
        Path to the executable to execute when the ThinkPad is placed
        on the dock.
        Ignored if the "dockHook" option is set.
      '';
    };

    dockHook = mkOption {
      type = types.str;
      default = "";
      description = ''
        Script to be executed when the ThinkPad is placed on the dock.
        If defined, the "dockHookPath" option will be ignored.
      '';
    };

    undockHookPath = mkOption {
      type = types.str;
      default = "/etc/dockd/undock.hook";
      description = ''
        Path to the executable to trigger when the ThinkPad is removed
        from the dock.
        Ignored if the "undockHook" option is set.
      '';
    };

    undockHook = mkOption {
      type = types.str;
      default = "";
      description = ''
        Script to be executed when the ThinkPad is removed from the dock.
        If defined, the "undockHookPath" option will be ignored.
      '';
    };

  };
  ##################################################
  config =
  let
    # override the paths on which the dockd executable
    # should lookup for the configuration and hook scripts
    dockd =
     pkgs.dockd.override {
       inherit (cfg) dockedConfPath undockedConfPath;
       dockHookPath = (if cfg.dockHook != ""
                       then pkgs.writeScript "dock.hook"
                       else cfg.dockHookPath);
       undockHookPath = (if cfg.undockHook != ""
                         then pkgs.writeScript "undock.hook" cfg.undockHook
                         else cfg.undockHookPath);
     };
  in mkIf cfg.enable {
    services.acpid.enable = true; # required for libthinkpad
    environment.systemPackages = [ dockd ];
    systemd.user.services.dockd = {
      description = "Lenovo ThinkPad Dock Daemon";
      after = [ "acpid.service" ];
      path = [ dockd ];
      environment = { DISPLAY = ":0"; };
      script = ''
        dockd --daemon
      '';
    };
  };
}
