{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.moonlight-qt;
in
{
  options.programs.moonlight-qt = {
    enable = lib.mkEnableOption "Moonlight Qt, a client for playing your PC games on almost any device";

    package = lib.mkPackageOption pkgs "moonlight-qt" { };

    capSysNice = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Add the CAP_SYS_NICE capability to Moonlight Qt so that it may raise
        its scheduling priority.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.moonlight = lib.mkIf cfg.capSysNice {
      owner = "root";
      group = "root";
      source = lib.getExe cfg.package;
      capabilities = "cap_sys_nice+ep";
    };
  };

  meta.maintainers = with lib.maintainers; [ aaravrav ];
}
