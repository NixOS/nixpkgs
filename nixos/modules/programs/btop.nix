{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.btop;
in
{
  options = {
    programs.btop = {
      enable = lib.mkEnableOption "Weather to enable setcap wrapper for btop , needed to show usage for intel GPUs.";
      package = lib.mkPackageOption pkgs "btop" { extraDescription = "The btop package to use."; };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.btop = {
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/btop";
      capabilities = "cap_perfmon+ep";
    };
    environment.systemPackages = [ cfg.package ];
  };

  meta = {
    maintainers = with lib.maintainers; [ mytagssma ];
  };
}
