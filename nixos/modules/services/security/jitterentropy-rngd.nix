{ lib, config, pkgs, ... }:
let
  cfg = config.services.jitterentropy-rngd;
in
{
  options.services.jitterentropy-rngd = {
    enable =
      lib.mkEnableOption "jitterentropy-rngd service configuration";
    package = lib.mkPackageOption pkgs "jitterentropy-rngd" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services."jitterentropy".wantedBy = [ "basic.target" ];
  };

  meta.maintainers = with lib.maintainers; [ thillux ];
}
