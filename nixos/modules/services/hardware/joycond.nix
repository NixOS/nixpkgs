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
    enable = lib.mkEnableOption "support for Nintendo Pro Controllers and Joy-Con";

    package = lib.mkPackageOption pkgs "joycond" { };

    fixBluetooth = lib.mkOption {
      default = false;
      defaultText = "false";
      example = "true";
      description = ''
        Whether to fix pairing of Nintendo Switch controllers by setting
        ClassicBondedOnly to false.

        Leaving this option enabled could expose your machine to security
        issues such as CVE-2023-45866. As such, the best practice is to
        enable this option, pair your controllers and then disable this option.

        Doing that may be impractical as if you ever pair your controller to a
        different device you'll probably have to re-pair the controller to your
        computer which will require you to toggle this option. A compromise
        might be to only enable Bluetooth when you want to use it and you're
        sure you're safe environment. If you have a desktop computer or simply
        a computer that stays in a safe environment (e.g. your home) then you
        can probably leave this option enabled.
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
    systemd.services.joycond.wantedBy = [ "multi-user.target" ];

    # Workaround for allowing Nintendo controllers to connect via Bluetooth
    hardware.bluetooth.input.General.ClassicBondedOnly = lib.mkDefault (!cfg.fixBluetooth);
  };
}
