{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.realm;
  configFormat = pkgs.formats.json { };
  configFile = configFormat.generate "config.json" cfg.config;
in
{

  meta.maintainers = with lib.maintainers; [ ocfox ];

  options = {
    services.realm = {
      enable = lib.mkEnableOption "A simple, high performance relay server written in rust";
      package = lib.mkPackageOption pkgs "realm" { };
      config = lib.mkOption {
        type = lib.types.submodule {
          freeformType = configFormat.type;
        };
        default = { };
        description = ''
          The realm configuration, see <https://github.com/zhboner/realm#overview> for documentation.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.realm = {
      serviceConfig = {
        DynamicUser = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectProc = "invisible";
        ProtectKernelTunables = true;
        ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
        ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
