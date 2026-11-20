{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.a2boot;
in
{
  options.services.a2boot = {
    enable = lib.mkEnableOption "the a2boot daemon";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.netatalk.partOf = [ "a2boot.service" ];
    systemd.services.a2boot = {
      description = "a2boot daemon";
      unitConfig.Documentation = "man:a2boot(8)";
      after = [
        "network.target"
        "netatalk.service"
      ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.netatalk ];

      serviceConfig = {
        Type = "forking";
        DynamicUser = true;
        RuntimeDirectory = "a2boot";
        ExecStart = "${pkgs.netatalk}/bin/a2boot";
        Restart = "always";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ matthewcroughan ];
}
