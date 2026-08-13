{
  config,
  pkgs,
  lib,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ sandarukasa ];

  options = {
    programs.compsize = {
      enable = lib.mkEnableOption "compsize + setcap wrapper";
      package = lib.mkPackageOption pkgs "compsize" { };
    };
  };

  config =
    let
      cfg = config.programs.compsize;
    in
    lib.mkIf cfg.enable {
      # for the man page
      environment.systemPackages = [ cfg.package ];

      security.wrappers.compsize = {
        owner = config.users.users.root.name;
        group = config.users.users.root.group;
        capabilities = "cap_sys_admin+p";
        source = lib.getExe cfg.package;
      };
    };
}
