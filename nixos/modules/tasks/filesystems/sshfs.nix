{ config, lib, pkgs, ... }:

{
  config = lib.mkIf
    (config.boot.supportedFilesystems.sshfs
      or config.boot.supportedFilesystems."fuse.sshfs"
      or false)
    {
      system.fsPackages = [ pkgs.sshfs ];
    };
}
