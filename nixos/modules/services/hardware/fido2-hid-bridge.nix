{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fido2-hid-bridge;
  desc = "PC/SC to FIDO2 over USB HID bridge";
in
{
  options.services.fido2-hid-bridge = {
    enable = lib.mkEnableOption desc;

    package = lib.mkPackageOption pkgs "fido2-hid-bridge" { };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "uhid" ];

    services.pcscd.enable = lib.mkDefault true;

    systemd.services.fido2-hid-bridge = {
      enable = lib.mkDefault true;

      description = desc;

      after = [ "pcscd.socket" ];
      requires = [ "pcscd.socket" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = "5s";

        # DynamicUser = true not possible since access control needs to be set up ahead of time
        User = "fido2-hid-bridge";
        Group = "fido2-hid-bridge";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;

        DevicePolicy = "closed";
        DeviceAllow = [ "/dev/uhid rw" ];

        BindPaths = [ "/run/pcscd/pcscd.comm" ];
      };
      unitConfig.ConditionPathExists = "/dev/uhid";
    };

    services.udev.extraRules = ''
      KERNEL=="uhid", RUN+="${lib.getExe' pkgs.acl "setfacl"} -m g:fido2-hid-bridge:rw /dev/uhid"
    '';

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.debian.pcsc-lite.access_pcsc" || action.id == "org.debian.pcsc-lite.access_card") && subject.isInGroup("fido2-hid-bridge")) {
          return polkit.Result.YES;
        }
      });
    '';

    users.users.fido2-hid-bridge = {
      description = "fido2-hid-bridge system service user";
      isSystemUser = true;
      group = "fido2-hid-bridge";
    };
    users.groups.fido2-hid-bridge = { };
  };

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
