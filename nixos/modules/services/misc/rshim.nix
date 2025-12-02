{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rshim;

  rshimCommand = [
    "${cfg.package}/bin/rshim"
  ]
  ++ lib.optionals (cfg.backend != null) [ "--backend ${cfg.backend}" ]
  ++ lib.optionals (cfg.device != null) [ "--device ${cfg.device}" ]
  ++ lib.optionals (cfg.index != null) [ "--index ${builtins.toString cfg.index}" ]
  ++ [ "--log-level ${builtins.toString cfg.log-level}" ];
in
{
  options.services.rshim = {
    enable = lib.mkEnableOption "user-space rshim driver for the BlueField SoC";

    package = lib.mkPackageOption pkgs "rshim-user-space" { };

    backend = lib.mkOption {
      type =
        with lib.types;
        nullOr (enum [
          "usb"
          "pcie"
          "pcie_lf"
        ]);
      description = ''
        Specify the backend to attach. If not specified, the driver will scan
        all rshim backends unless the `device` option is given with a device
        name specified.
      '';
      default = null;
      example = "pcie";
    };

    device = lib.mkOption {
      type = with lib.types; nullOr str;
      description = ''
        Specify the device name to attach. The backend driver can be deduced
        from the device name, thus the `backend` option is not needed.
      '';
      default = null;
      example = "pcie-04:00.2";
    };

    index = lib.mkOption {
      type = with lib.types; nullOr int;
      description = ''
        Specify the index to create device path `/dev/rshim<index>`. It's also
        used to create network interface name `tmfifo_net<index>`. This option
        is needed when multiple rshim instances are running.
      '';
      default = null;
      example = 1;
    };

    log-level = lib.mkOption {
      type = lib.types.ints.between 0 4;
      description = ''
        Specify the log level (0:none, 1:error, 2:warning, 3:notice, 4:debug).
      '';
      default = 2;
      example = 4;
    };

    config = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          int
          str
        ]);
      description = ''
        Structural setting for the rshim configuration file
        (`/etc/rshim.conf`). It can be used to specify the static mapping
        between rshim devices and rshim names. It can also be used to ignore
        some rshim devices.
      '';
      default = { };
      example = {
        DISPLAY_LEVEL = 0;
        rshim0 = "usb-2-1.7";
        none = "usb-1-1.4";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc = lib.mkIf (cfg.config != { }) {
      "rshim.conf".text = lib.generators.toKeyValue {
        mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
      } cfg.config;
    };

    systemd.services.rshim = {
      after = [ "network.target" ];
      serviceConfig = {
        Restart = "always";
        Type = "forking";
        ExecStart = [
          (lib.concatStringsSep " \\\n" rshimCommand)
        ];
        KillMode = "control-group";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ nikstur ];
}
