{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.token2-fido-bridge;
in
{
  options.services.token2-fido-bridge = {
    enable = lib.mkEnableOption "FIDO2 PC/SC to USB-HID bridge (WebAuthn for smartcards)";

    package = (lib.mkPackageOption pkgs "token2-fido-bridge" { }) // {
      default = pkgs.token2-fido-bridge;
      defaultText = lib.literalExpression "pkgs.token2-fido-bridge";
    };

    settings = {
      vendorId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "0x349E";
        description = "USB vendor ID";
      };

      productId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "0x0001";
        description = "USB product ID";
      };

      deviceName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "My Virtual Key";
        description = "Device name";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.services.token2-fido-bridge = {
      environment = {
        FIDO2_BRIDGE_VID = cfg.settings.vendorId;
        FIDO2_BRIDGE_PID = cfg.settings.productId;
        FIDO2_BRIDGE_NAME = cfg.settings.deviceName;
      };
      # have to define again because [Install] in included file not honored
      # https://github.com/NixOS/nixpkgs/issues/81138
      wantedBy = [ "multi-user.target" ];
    };
  };
}
