{ config, lib, pkgs, ... }:

let
  cfg = config.programs.screen;
in

{
  options = {
    programs.screen = {
      enable = lib.mkEnableOption "screen, a basic terminal multiplexer";

      package = lib.mkPackageOption pkgs "screen" { };

      screenrc = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          defscrollback 10000
          startup_message off
        '';
        description = "The contents of {file}`/etc/screenrc` file";
      };
    };
  };

  config = lib.mkMerge [
    {
      # TODO: Added in 24.05, remove before 24.11
      assertions = [
        {
          assertion = cfg.screenrc != "" -> cfg.enable;
          message = "`programs.screen.screenrc` has been configured, but `programs.screen.enable` is not true";
        }
      ];
    }
    (lib.mkIf cfg.enable {
      environment.etc.screenrc = {
        text = cfg.screenrc;
      };
      environment.systemPackages = [ cfg.package ];
      security.pam.services.screen = {};
    })
  ];
}
