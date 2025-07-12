{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bt-dualboot;

  escapedMountPoint = lib.pipe cfg.mountPoint [
    lib.strings.normalizePath
    (lib.removePrefix "/")
    (lib.removeSuffix "/")
    (builtins.replaceStrings [ "/" ] [ "-" ])
  ];

in
{

  meta.maintainers = [ lib.maintainers.bmrips ];

  options.services.bt-dualboot = {
    enable = lib.mkEnableOption "{command}`bt-dualboot`";
    package = lib.mkPackageOption pkgs "bt-dualboot" { };
    mountPoint = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "/mnt";
      description = ''
        The mount point of the Windows data partition. By default,
        {command}`bt-dualboot` will recognize and use mount Windows partitions
        automatically.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.bt-dualboot =
      {
        description = "Copy bluetooth pairing keys to Windows before shutdown";
        wantedBy = [ "multi-user.target" ];

        # Use `RemainAfterExit` and `ExecStop` to run on shutdown
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop =
            "${pkgs.bt-dualboot}/bin/bt-dualboot --backup --sync-all"
            + lib.optionalString (cfg.mountPoint != null) " --win ${cfg.mountPoint}";
        };
      }
      // lib.optionalAttrs (cfg.mountPoint != null) {
        requires = [ "${escapedMountPoint}.mount" ];
        after = [ "${escapedMountPoint}.mount" ];
      };

  };

}
