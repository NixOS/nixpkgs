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

        Make sure the file exists and is writable by the user of the session.
      '';
    };

    undockedConfPath = mkOption {
      type = types.str;
      default = "/etc/dockd/undocked.conf";
      description = ''
        Path to the file that will store the configuration of the
        environment when the ThinkPad is removed from the dock.

        Make sure the file exists and is writable by the user of the session.
      '';
    };

    dockHookPath = mkOption {
      type = types.str;
      default = "";
      description = ''
        Path to the executable to run when the ThinkPad is placed on the dock.
        If set, make sure the file exists and is executable by the user of the session.

        Example: "/etc/dockd/dock.hook"

        This option is mutually exclusive the "dockHook" option.
      '';
    };

    dockHook = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Script to be executed when the ThinkPad is placed on the dock.
        If is set to null (the default) then create dummy script to
        fulfill the expectations of dockd.

        Example:  "echo docked"

        This option is mutually exclusive to the "dockHookPath" option.
      '';
    };

    undockHookPath = mkOption {
      type = types.str;
      default = "";
      description = ''
        Path to the executable to run when the ThinkPad is removed from the dock.

        Example: "/etc/dockd/undock.hook"

        If set, make sure the file exists and is executable by the user of the session.

        This option is mutually exclusive to the "undockHook" option.
      '';
    };

    undockHook = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Script to be executed when the ThinkPad is removed from the dock.
        If is set to null (the default) then create dummy script to
        fulfill the expectations of dockd.

        Example:  "echo undocked"

        This option is mutually exclusive to the "undockHookPath" option.
      '';
    };

  };
  ##################################################
  config =
    let
       # override the paths on which the dockd executable
       # should lookup for the configuration and hook scripts
       dockd =
        # configure a default script content if the dockHook or undockHook hook is
        # set to null, specified that the user is not interested on doing nothing
        # with the hooks
        let
          dockHook = if cfg.dockHook == null then "exit 0" else cfg.dockHook;
          undockHook = if cfg.undockHook == null then "exit 0" else cfg.undockHook;
          inherit(pkgs) writeScript;
        in
        pkgs.dockd.override {
          inherit (cfg) dockedConfPath undockedConfPath;
          dockHookPath = (if dockHook  != ""
                          then writeScript "dock.hook" dockHook
                          else cfg.dockHookPath);
          undockHookPath = (if undockHook  != ""
                            then writeScript "undock.hook" undockHook
                            else cfg.undockHookPath);
        };
    in
    mkIf cfg.enable {
    assertions = [
      # verify that only one of (dockHook | dockHookPath) is defined
      {
        assertion =
         if ((cfg.dockHook != null && cfg.dockHook != "") && (cfg.dockHookPath != ""))
         then false else true;
        message = ''
        You have to define ONLY one of "dockHook" or "dockHookPath"
        '';
      }
      # verify that only one of (undockHook | undockHookPath) is defined
      {
        assertion =
          if ((cfg.undockHook != null && cfg.undockHook != "") && (cfg.undockHookPath != ""))
          then false else true;
        message = ''
        You have to define ONLY one of "undockHook" or "undockHookPath"
        '';
      }
      # if the dockHookPath is used, verify the path exists
      {
        assertion =
          if cfg.dockHookPath != "" then
          (builtins.pathExists cfg.dockHookPath) else true;
        message = ''
          The path in "dockHookPath" does not exists.
        '';
      }
      # if the undockHookPath is used, verify the path exists
      {
        assertion =
         if cfg.undockHookPath != "" then
         (builtins.pathExists cfg.undockHookPath) else true;
        message = ''
          The path in "undockHookPath" does not exists.
        '';
      }
    ];
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
