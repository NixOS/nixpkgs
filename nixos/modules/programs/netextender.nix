{
  lib,
  config,
  netextender,
  ...
}:

let
  cfg = config.programs.netextender;
in

{
  options = {
    programs.netextender = {
      enable = lib.mkEnableOption "SonicWall NetExtender service";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ netextender ];

    systemd.services.netextender = {
      description = "SonicWall NetExtender service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${netextender}/bin/NEService";
        KillMode = "process";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    JacoMalan1
  ];
}
