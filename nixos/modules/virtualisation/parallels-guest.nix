{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  prl-tools = config.hardware.parallels.package;
in

{

  imports = [
    (mkRemovedOptionModule [
      "hardware"
      "parallels"
      "autoMountShares"
    ] "Shares are always automatically mounted since Parallels Desktop 20.")
  ];

  options = {
    hardware.parallels = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This enables Parallels Tools for Linux guests.
        '';
      };

      package = lib.mkPackageOption pkgs "prl-tools" { };
    };

  };

  config = mkIf config.hardware.parallels.enable {

    services.udev.packages = [ prl-tools ];

    environment.systemPackages = [ prl-tools ];

    boot.extraModulePackages = [ prl-tools ];

    services.timesyncd.enable = false;

    # Parallels Desktop 26+ mounts shared folders under /mnt/psf by default.
    # prltoolsd tries to create subdirectories there at runtime, which fails
    # if /mnt/psf does not exist. Create it declaratively via tmpfiles.
    systemd.tmpfiles.rules = [
      "d /mnt/psf 0755 root root - -"
    ];

    systemd.services.prltoolsd = {
      description = "Parallels Tools Service";
      wantedBy = [ "multi-user.target" ];
      # prltoolsd mount scripts invoke coreutils (tail, mkdir, chmod)
      # and gnused (sed) without inheriting the service PATH in all
      # code paths. Make them available alongside prl-tools.
      path = [
        prl-tools
        pkgs.coreutils
        pkgs.gnused
      ];
      serviceConfig = {
        ExecStart = "${prl-tools}/bin/prltoolsd -f";
        PIDFile = "/var/run/prltoolsd.pid";
        WorkingDirectory = "${prl-tools}/bin";
      };
    };

    systemd.services.prlshprint = {
      description = "Parallels Printing Tool";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "cups.service" ];
      path = [ prl-tools ];
      serviceConfig = {
        ExecStart = "${prl-tools}/bin/prlshprint";
        WorkingDirectory = "${prl-tools}/bin";
      };
    };

    systemd.user.services.prlcc = {
      description = "Parallels Control Center";
      wantedBy = [ "graphical-session.target" ];
      path = [ prl-tools ];
      serviceConfig = {
        ExecStart = "${prl-tools}/bin/prlcc";
        WorkingDirectory = "${prl-tools}/bin";
      };
    };
  };

  meta.maintainers = with maintainers; [ codgician ];
}
