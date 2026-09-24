{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.boot.supportedFilesystems."fuse.bindfs" or false) {
    system.fsPackages = [ pkgs.bindfs ];
  };

  meta = {
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
