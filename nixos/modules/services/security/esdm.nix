{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.esdm;
in
{
  imports = [
    # removed option 'services.esdm.cuseRandomEnable'
    (lib.mkRemovedOptionModule [ "services" "esdm" "cuseRandomEnable" ] ''
      Use services.esdm.enableLinuxCompatServices instead.
    '')
    # removed option 'services.esdm.cuseUrandomEnable'
    (lib.mkRemovedOptionModule [ "services" "esdm" "cuseUrandomEnable" ] ''
      Use services.esdm.enableLinuxCompatServices instead.
    '')
    # removed option 'services.esdm.procEnable'
    (lib.mkRemovedOptionModule [ "services" "esdm" "procEnable" ] ''
      Use services.esdm.enableLinuxCompatServices instead.
    '')
    # removed option 'services.esdm.verbose'
    (lib.mkRemovedOptionModule [ "services" "esdm" "verbose" ] ''
      There is no replacement.
    '')
  ];

  options.services.esdm = {
    enable = lib.mkEnableOption "ESDM service configuration";
    package = lib.mkPackageOption pkgs "esdm" { };
    enableLinuxCompatServices = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable /dev/random, /dev/urandom and /proc/sys/kernel/random/* userspace wrapper.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        systemd.packages = [ cfg.package ];
        systemd.services."esdm-server".wantedBy = [ "basic.target" ];
      }
      # It is necessary to set those options for these services to be started by systemd in NixOS
      (lib.mkIf cfg.enableLinuxCompatServices {
        systemd.targets."esdm-linux-compat".wantedBy = [ "basic.target" ];
        systemd.services."esdm-server-suspend".wantedBy = [
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
        systemd.services."esdm-server-resume".wantedBy = [
          "sleep.target"
          "suspend.target"
          "hibernate.target"
        ];
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    orichter
    thillux
  ];
}
