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
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ librepods ];
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
