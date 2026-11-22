{
  config,
  pkgs,
  lib,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ sandarukasa ];

  options = {
    programs.btrfs-heatmap = {
      enable = lib.mkEnableOption "btrfs-heatmap + setcap wrapper";
      package = lib.mkPackageOption pkgs "btrfs-heatmap" { };
    };
  };

  config =
    let
      cfg = config.programs.btrfs-heatmap;
    in
    lib.mkIf cfg.enable {
      # for the man page
      environment.systemPackages = [ cfg.package ];

      security.wrappers.btrfs-heatmap = {
        owner = config.users.users.root.name;
        group = config.users.users.root.group;
        capabilities = "cap_sys_admin+p";
        source = lib.getExe cfg.package;
      };
    };
}
