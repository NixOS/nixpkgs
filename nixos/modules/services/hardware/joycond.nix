{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.joycond;
in
{
  options.services.joycond = {
    enable = lib.mkEnableOption "support for Nintendo Pro Controllers and Joycons";

    package = lib.mkPackageOption pkgs "joycond" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
    systemd.services.joycond.wantedBy = [ "multi-user.target" ];
  };
}
