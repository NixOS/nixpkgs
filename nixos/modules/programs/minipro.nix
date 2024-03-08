{ config, lib, pkgs, ... }:

let
  cfg = config.programs.minipro;
in
{
  options = {
    programs.minipro = {
      enable = lib.mkEnableOption (lib.mdDoc "minipro") // {
        description = lib.mdDoc ''
          Installs minipro and its udev rules.
          Users of the `plugdev` group can interact with connected MiniPRO chip programmers.
        '';
      };

      package = lib.mkPackageOption pkgs "minipro" { };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.plugdev = { };
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };

  meta = {
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
