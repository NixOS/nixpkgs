{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.autoenv;
in
{
  options = {
    programs.autoenv = {
      enable = lib.mkEnableOption "autoenv";
      package = lib.mkPackageOption pkgs "autoenv" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/share/autoenv" ];
    environment.systemPackages = [ pkgs.autoenv ];

    programs = {
      zsh.interactiveShellInit = ''
        source ${cfg.package}/share/autoenv/activate.sh
      '';

      bash.interactiveShellInit = ''
        source ${cfg.package}/share/autoenv/activate.sh
      '';

      dash.interactiveShellInit = ''
        source ${cfg.package}/share/autoenv/activate.sh
      '';

    };
  };
}
