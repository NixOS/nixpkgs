{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nethoscope;
in
{
  meta.maintainers = with lib.maintainers; [ _0x4A6F ];

  options = {
    programs.nethoscope = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to add nethoscope to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nethoscope ];
    security.wrappers.nethoscope = {
      source = "${pkgs.nethoscope}/bin/nethoscope";
      capabilities = "cap_net_raw,cap_net_admin=eip";
    };
  };
}
