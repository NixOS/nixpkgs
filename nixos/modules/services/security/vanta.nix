{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vanta-agent;
in
{
  options = {
    services.vanta-agent = {
      enable = lib.mkEnableOption "Vanta Agent";
      package = lib.mkPackageOption pkgs "vanta-agent" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "L+ /var/vanta - - - - /var/lib/vanta"
    ];

    systemd.services.vanta.serviceConfig = {
      StateDirectory = "vanta";
      ExecStartPre = [
        "${pkgs.bash}/bin/bash -c 'cp ${cfg.package}/var/vanta/* /var/vanta/'"
      ];
    };
  };
}
