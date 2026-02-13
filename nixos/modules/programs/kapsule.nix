{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.kapsule;
in
{
  options.programs.kapsule = {
    enable = lib.mkEnableOption "kapsule";
    package = lib.mkPackageOption pkgs [
      "kdePackages"
      "kapsule"
    ] { };
    settings = lib.mkOption {

    };
  };
  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];

    virtualisation.incus = {
      enable = true;
      socketActivation = lib.mkDefault true;
    };

    systemd.services.incus = {
      # See https://invent.kde.org/kde-linux/kapsule/-/blob/d311acfdef187433568e32fada90a0f6dcfaac9b/data/systemd/system/incus.service.d/kapsule-log-dir.conf
      serviceConfig = {
        ExecStart = lib.mkAfter [
          ""
          "${config.virtualisation.incus.package}/bin/incusd --group=wheel --logfile=/var/log/incus/incusd.log"
        ];
      };
    };

    systemd.services.kapsule-daemon = {
      path = [ config.virtualisation.incus.package ];
    };

    systemd.tmpfiles.rules = [
      "d /var/log/incus 0750 root root - -"
    ];
  };
}
