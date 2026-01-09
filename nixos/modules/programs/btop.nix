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
      enable = lib.mkEnableOption "a setcap wrapper for btop";
      package = lib.mkPackageOption pkgs "btop" { extraDescription = "can use btop-cuda or btop-rocm"; };
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
