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
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.btop = {
      owner = "root";
      group = "root";
      source = "${pkgs.btop}/bin/btop";
      capabilities = "cap_perfmon+ep";
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ mytagssma ];
  };
}
