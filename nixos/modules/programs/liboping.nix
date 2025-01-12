{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.liboping;
in
{
  options.programs.liboping = {
    enable = lib.mkEnableOption "liboping";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ liboping ];
    security.wrappers = lib.mkMerge (
      builtins.map
        (exec: {
          "${exec}" = {
            owner = "root";
            group = "root";
            capabilities = "cap_net_raw+p";
            source = "${pkgs.liboping}/bin/${exec}";
          };
        })
        [
          "oping"
          "noping"
        ]
    );
  };
}
