{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.services.systemd-lock-handler;
  inherit (lib) mkIf mkEnableOption mkPackageOption;
in
{
  options.services.systemd-lock-handler = {
    enable = mkEnableOption (lib.mdDoc "systemd-lock-handler");
    package = mkPackageOption pkgs "systemd-lock-handler" { };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    # https://github.com/NixOS/nixpkgs/issues/81138
    systemd.user.services.systemd-lock-handler.wantedBy = [ "default.target" ];
  };

  meta = {
    maintainers = with lib.maintainers; [ liff ];
    doc = ./systemd-lock-handler.md;
  };
}
