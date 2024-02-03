{ config, lib, pkgs, ... }:

let
  cfg = config.programs.screen;
in

{
  options = {
    programs.screen = {
      enable = lib.mkEnableOption (lib.mdDoc "screen, a basic terminal multiplexer");

      package = lib.mkPackageOptionMD pkgs "screen" { };

      screenrc = lib.mkOption {
        type = with lib.types; nullOr lines;
        example = ''
          defscrollback 10000
          startup_message off
        '';
        description = lib.mdDoc "The contents of {file}`/etc/screenrc` file";
      };
    };
  };

  config = {
    # TODO: Added in 24.05, remove before 24.11
    assertions = [
      {
        assertion = cfg.screenrc != null -> cfg.enable;
        message = "`programs.screen.screenrc` has been configured, but `programs.screen.enable` is not true";
      }
    ];
  } // lib.mkIf cfg.enable {
    environment.etc.screenrc = {
      enable = cfg.screenrc != null;
      text = cfg.screenrc;
    };
    environment.systemPackages = [ cfg.package ];
    security.pam.services.screen = {};
  };
}
