{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.librepods;
in
{
  options = {
    programs.librepods = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to configure system to enable librepods.
          To grant access to a user, it must be part of librepods group:
          `users.users.alice.extraGroups = ["librepods"];`
        '';
      };
      extraPackages = lib.mkOption {
        type = with lib.types; listOf package;
        default = with pkgs; [ ];
        example = lib.literalExpression ''
          with pkgs; [ gnomeExtensions.appindicator ]
        '';
        description = ''
          Extra packages to be installed system wide.
          If you are on GNOME you could add `gnomeExtensions.appindicator` to use the tray icon.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ librepods ] ++ cfg.extraPackages;
    users.groups.librepods = { };

    security.wrappers.librepods = {
      source = lib.getExe pkgs.librepods;
      capabilities = "cap_net_admin+ep";
      owner = "root";
      group = "librepods";
    };
  };

  meta.maintainers = [ lib.maintainers.Cameo007 ];
}
