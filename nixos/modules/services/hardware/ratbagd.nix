{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ratbagd;
in
{
  ###### interface

  options = {
    services.ratbagd = {
      enable = lib.mkEnableOption "ratbagd for configuring gaming mice";

      package = lib.mkPackageOption pkgs "libratbag" { };

      verbose = lib.mkOption {
        type = lib.types.enum [
          "quiet"
          "info"
          "debug"
          "raw"
        ];
        default = "info";
        description = "Verbosity level";
      };

      extraDevices = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = lib.literalExpression ''
          {
            logitech-g700 = '''
              [Device]
              Name=Logitech G700
              DeviceMatch=usb:046d:c06b
              Driver=hidpp10
              DeviceType=mouse
            ''';
          }
        '';
        description = "Additional device description files";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    # Give users access to the "ratbagctl" tool
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.ratbagd = {
      serviceConfig.ExecStart =
        let
          arg =
            {
              quiet = "--quiet";
              info = "";
              debug = "--verbose=debug";
              raw = "--verbose=raw";
            }
            .${cfg.verbose};
        in
        # If stdout is not a TTY, ratbagd logging is not line buffered, so if
        # it doesn't print a lot, you will never see anything. Run with
        # stdbuf as a workaround.
        [
          ""
          "${pkgs.coreutils}/bin/stdbuf -oL ${cfg.package}/bin/ratbagd ${arg}"
        ];

      environment.LIBRATBAG_DATA_DIR =
        let
          makeDev = name: text: lib.nameValuePair "${name}.device" (pkgs.writeText "${name}.device" text);
        in
        lib.mkIf (cfg.extraDevices != { }) (
          pkgs.symlinkJoin {
            name = "libratbag-devices";
            paths = [
              "${cfg.package}/share/libratbag"
              (pkgs.linkFarm "libratbag-extra-devices" (lib.mapAttrs' makeDev cfg.extraDevices))
            ];
          }
        );
    };
  };
}
