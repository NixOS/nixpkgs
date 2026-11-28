{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dmemcg-booster;
in
{
  options.services.dmemcg-booster = {
    enable = lib.mkEnableOption "Service for enabling and controlling dmem cgroup limits for boosting foreground games";
    package = lib.mkPackageOption pkgs "dmemcg-booster" { };
    type = lib.mkOption {
      default = "system";
      description = "Whether to use the dmemcg-booster system service or user service";
      type = lib.types.enum [
        "system"
        "user"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      packages = [ cfg.package ];
      services = lib.mkIf (cfg.type == "system") {
        dmemcg-booster-system.wantedBy = [ "multi-user.target" ];
      };
      user.services = lib.mkIf (cfg.type == "user") {
        dmemcg-booster-user.wantedBy = [ "graphical-session-pre.target" ];
      };
    };
  };

  meta = { inherit (pkgs.dmemcg-booster.meta) maintainers; };
}
