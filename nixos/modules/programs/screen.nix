{
  config,
  lib,
  pkgs,
  ...
}:

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
    (lib.mkIf cfg.enable {
      environment.etc.screenrc = {
        text = cfg.screenrc;
      };
      environment.systemPackages = [ cfg.package ];
      security.pam.services.screen = { };
    })
  ];
}
