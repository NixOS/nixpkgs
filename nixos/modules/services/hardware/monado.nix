{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf mkPackageOption;

  cfg = config.services.monado;
in
{
  options.services.monado = {
    enable = mkEnableOption "Monado wrapper and user service";

    package = mkPackageOption pkgs "monado" { };
  };

  config = mkIf cfg.enable {
    security.wrappers."monado-service" = {
      setuid = false;
      owner = "root";
      group = "root";
      # cap_sys_nice needed for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = "${cfg.package}/bin/monado-service";
    };

    systemd.user = {
      services.monado = {
        description = "Monado XR runtime service module";
        requires = [ "monado.socket" ];
        conflicts = [ "monado-dev.service" ];

        unitConfig.ConditionUser = "!root";

        environment = {
          # Default options
          # https://gitlab.freedesktop.org/monado/monado/-/blob/4548e1738591d0904f8db4df8ede652ece889a76/src/xrt/targets/service/monado.in.service#L12
          XRT_COMPOSITOR_LOG = mkDefault "debug";
          XRT_PRINT_OPTIONS = mkDefault "on";
          IPC_EXIT_ON_DISCONNECT = mkDefault "off";
        };

        serviceConfig = {
          ExecStart = "${config.security.wrapperDir}/monado-service";
          Restart = "no";
        };

        restartTriggers = [ cfg.package ];
      };

      sockets.monado = {
        description = "Monado XR service module connection socket";
        conflicts = [ "monado-dev.service" ];

        unitConfig.ConditionUser = "!root";

        socketConfig = {
          ListenStream = "%t/monado_comp_ipc";
          RemoveOnStop = true;
        };

        restartTriggers = [ cfg.package ];

        wantedBy = [ "sockets.target" ];
      };
    };

    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ Scrumplex ];
}
