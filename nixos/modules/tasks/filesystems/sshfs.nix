{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (lib.any (fs: fs == "sshfs" || fs == "fuse.sshfs") config.boot.supportedFilesystems) {
    system.fsPackages = [ pkgs.sshfs ];
  };
}
