{
  config,
  lib,
  pkgs,
  ...
}:

{
  config =
    lib.mkIf
      (config.boot.supportedFilesystems.sshfs or config.boot.supportedFilesystems."fuse.sshfs" or false)
      {
        programs.fuse.enable = true;

        system.fsPackages = [ pkgs.sshfs ];
      };
}
