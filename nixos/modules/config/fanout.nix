{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fanout;
  mknodCmds =
    n:
    lib.lists.imap0 (i: s: "mknod /dev/fanout${builtins.toString i} c $MAJOR ${builtins.toString i}") (
      lib.lists.replicate n ""
    );
in
{
  options.services.fanout = {
    enable = lib.mkEnableOption "fanout";
    fanoutDevices = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Number of /dev/fanout devices";
    };
    bufferSize = lib.mkOption {
      type = lib.types.int;
      default = 16384;
      description = "Size of /dev/fanout buffer in bytes";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ config.boot.kernelPackages.fanout.out ];

    boot.kernelModules = [ "fanout" ];

    boot.extraModprobeConfig = ''
      options fanout buffersize=${builtins.toString cfg.bufferSize}
    '';

    systemd.services.fanout = {
      description = "Bring up /dev/fanout devices";
      script = ''
        MAJOR=$(${pkgs.gnugrep}/bin/grep fanout /proc/devices | ${pkgs.gawk}/bin/awk '{print $1}')
        ${lib.strings.concatLines (mknodCmds cfg.fanoutDevices)}
      '';

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = "yes";
        Restart = "no";
      };
    };
  };
}
